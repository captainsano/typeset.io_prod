var mongoose = require('mongoose');
var mockgoose = require('mockgoose');
mockgoose(mongoose);                     // Wrap mongoose with mockgoose

var socket = require('../mocks/socket');

var chai = require('chai');
var assert = chai.assert,
    expect = chai.expect,
    should = chai.should();

/**
 * Tests check the sub-section handling capabilities in a research documents
 * NOTE: These tests are intended for continous execution and requires a document
 */
describe('Section Handling', function() {
    var Document, Delta, document, docid, Composer;

    // Global Setup
    before(function() {
        mockgoose.reset();
        Document = require('../lib/models/Document')(mongoose);
        Delta = require('../lib/models/Delta')(mongoose);
        Composer = require('../lib/research-delta-composer')(mongoose);
    });

    after(function() {
        mockgoose.reset();
        socket.offAll();
    });

    // NOT A TEST CASE
    it('[PRETEST]: Create a sample document', function(done) {
        document = new Document({title: 'Sample Research'})
        document.save(function(err, _document) {
            document = _document;
            docid = document._id.toString();
            require('../lib/research-editor')(socket, mongoose, document);

            // Add two sample sections
            socket.invoke('section.add', {section_id: 'abc', index: 0}, function() {
                socket.invoke('section.add', {section_id: 'def', index: 1}, function() {
                    done();
                });
            });
        });
    });

    //----------------------- Adding Sub-Sections -----------------------
    it('Should be able to create a new subsection', function(done) {
        socket.invoke('subsection.add', {section_id: 'abc', subsection_id: '1efc', index: 0}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one subsection
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(3);

                delta = results[2];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('1efc');
                expect(delta.args.index).to.equal(0);

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections[0].subsections.length).to.equal(1);
                    expect(composedDocument.sections[0].subsections[0].id).to.equal('1efc');
                    done();
                });
            });
        });
    });

    it('Should be able to add a subsection at the beginning', function(done) {
        socket.invoke('subsection.add', {section_id: 'abc', subsection_id: 'acfc', index: 0}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one subsection
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(4);

                delta = results[2];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('1efc');
                expect(delta.args.index).to.equal(0);

                delta = results[3];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('acfc');
                expect(delta.args.index).to.equal(0);

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections[0].subsections.length).to.equal(2);
                    expect(composedDocument.sections[0].subsections[0].id).to.equal('acfc');
                    expect(composedDocument.sections[0].subsections[1].id).to.equal('1efc');
                    done();
                });
            });
        });
    });

    it('Should be able to add a subsection at the end', function(done) {
        socket.invoke('subsection.add', {section_id: 'abc', subsection_id: 'nc7a', index: 2}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one subsection
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(5);

                delta = results[2];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('1efc');
                expect(delta.args.index).to.equal(0);

                delta = results[3];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('acfc');
                expect(delta.args.index).to.equal(0);

                delta = results[4];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('nc7a');
                expect(delta.args.index).to.equal(2);

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections[0].subsections.length).to.equal(3);
                    expect(composedDocument.sections[0].subsections[0].id).to.equal('acfc');
                    expect(composedDocument.sections[0].subsections[1].id).to.equal('1efc');
                    expect(composedDocument.sections[0].subsections[2].id).to.equal('nc7a');
                    done();
                });
            });
        });
    });

    it('Should be able to add a subsection in the middle', function(done) {
        socket.invoke('subsection.add', {section_id: 'abc', subsection_id: 'xbmc', index: 1}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one subsection
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(6);

                delta = results[2];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('1efc');
                expect(delta.args.index).to.equal(0);

                delta = results[3];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('acfc');
                expect(delta.args.index).to.equal(0);

                delta = results[4];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('nc7a');
                expect(delta.args.index).to.equal(2);

                delta = results[5];

                expect(delta.name).to.equal('subsection.add');
                expect(delta.args.section_id).to.equal('abc');
                expect(delta.args.subsection_id).to.equal('xbmc');
                expect(delta.args.index).to.equal(1);

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections[0].subsections.length).to.equal(4);
                    expect(composedDocument.sections[0].subsections[0].id).to.equal('acfc');
                    expect(composedDocument.sections[0].subsections[1].id).to.equal('xbmc');
                    expect(composedDocument.sections[0].subsections[2].id).to.equal('1efc');
                    expect(composedDocument.sections[0].subsections[3].id).to.equal('nc7a');
                    done();
                });
            });
        });
    });
});