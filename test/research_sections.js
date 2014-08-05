var mongoose = require('mongoose');
var mockgoose = require('mockgoose');
mockgoose(mongoose);                     // Wrap mongoose with mockgoose

var socket = require('../mocks/socket');

var chai = require('chai');
var assert = chai.assert,
    expect = chai.expect,
    should = chai.should();

/**
 * Tests check the section handling capabilities in a research documents
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
            done();
        });
    });

    //----------------------- Adding Sections -----------------------
    it('Should be able to create a new section', function(done) {
        socket.invoke('section.add', {section_id: 'a1bc', index: 0}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one section
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(1);

                delta = results[0];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('a1bc');
                expect(delta.args.index).to.equal(0);

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections.length).to.equal(1);
                    expect(composedDocument.sections[0].id).to.equal('a1bc');
                    done();
                });
            });
        });
    });

    it('Should be able to add another section at beginning', function(done) {
        socket.invoke('section.add', {section_id: 'x9da', index: 0}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one section
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(2);

                delta = results[0];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('a1bc');
                expect(delta.args.index).to.equal(0);

                delta = results[1];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('x9da');
                expect(delta.args.index).to.equal(0);

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections.length).to.equal(2);
                    expect(composedDocument.sections[0].id).to.equal('x9da');
                    expect(composedDocument.sections[1].id).to.equal('a1bc');
                    done();
                });
            });
        });
    });

    it('Should be able to add section at end', function(done) {
        socket.invoke('section.add', {section_id: 'cd15', index: 2}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one section
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(3);

                delta = results[0];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('a1bc');
                expect(delta.args.index).to.equal(0);

                delta = results[1];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('x9da');
                expect(delta.args.index).to.equal(0);

                delta = results[2];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('cd15');
                expect(delta.args.index).to.equal(2);

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections.length).to.equal(3);
                    expect(composedDocument.sections[0].id).to.equal('x9da');
                    expect(composedDocument.sections[1].id).to.equal('a1bc');
                    expect(composedDocument.sections[2].id).to.equal('cd15');
                    done();
                });
            });
        });
    });

    it('Should be able to add section at beginning', function(done) {
        socket.invoke('section.add', {section_id: 'h7af', index: 1}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one section
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(4);

                delta = results[0];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('a1bc');
                expect(delta.args.index).to.equal(0);

                delta = results[1];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('x9da');
                expect(delta.args.index).to.equal(0);

                delta = results[2];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('cd15');
                expect(delta.args.index).to.equal(2);

                delta = results[3];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('h7af');
                expect(delta.args.index).to.equal(1);

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections.length).to.equal(4);
                    expect(composedDocument.sections[0].id).to.equal('x9da');
                    expect(composedDocument.sections[1].id).to.equal('h7af');
                    expect(composedDocument.sections[2].id).to.equal('a1bc');
                    expect(composedDocument.sections[3].id).to.equal('cd15');
                    done();
                });
            });
        });
    });

    //----------------------- Deleting Sections -----------------------
    it('Should be able to delete section from the middle', function(done) {
        socket.invoke('section.delete', {section_id: 'h7af'}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one section
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(5);

                delta = results[0];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('a1bc');
                expect(delta.args.index).to.equal(0);

                delta = results[1];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('x9da');
                expect(delta.args.index).to.equal(0);

                delta = results[2];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('cd15');
                expect(delta.args.index).to.equal(2);

                delta = results[3];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('h7af');
                expect(delta.args.index).to.equal(1);

                delta = results[4];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('h7af');

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections.length).to.equal(3);
                    expect(composedDocument.sections[0].id).to.equal('x9da');
                    expect(composedDocument.sections[1].id).to.equal('a1bc');
                    expect(composedDocument.sections[2].id).to.equal('cd15');
                    done();
                });
            });
        });
    });

    it('Should be able to delete section from beginning', function(done) {
        socket.invoke('section.delete', {section_id: 'x9da'}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one section
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(6);

                delta = results[0];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('a1bc');
                expect(delta.args.index).to.equal(0);

                delta = results[1];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('x9da');
                expect(delta.args.index).to.equal(0);

                delta = results[2];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('cd15');
                expect(delta.args.index).to.equal(2);

                delta = results[3];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('h7af');
                expect(delta.args.index).to.equal(1);

                delta = results[4];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('h7af');

                delta = results[5];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('x9da');

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections.length).to.equal(2);
                    expect(composedDocument.sections[0].id).to.equal('a1bc');
                    expect(composedDocument.sections[1].id).to.equal('cd15');
                    done();
                });
            });
        });
    });

    it('Should be able to delete section from end', function(done) {
        socket.invoke('section.delete', {section_id: 'cd15'}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one section
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(7);

                delta = results[0];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('a1bc');
                expect(delta.args.index).to.equal(0);

                delta = results[1];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('x9da');
                expect(delta.args.index).to.equal(0);

                delta = results[2];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('cd15');
                expect(delta.args.index).to.equal(2);

                delta = results[3];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('h7af');
                expect(delta.args.index).to.equal(1);

                delta = results[4];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('h7af');

                delta = results[5];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('x9da');

                delta = results[6];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('cd15');

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections.length).to.equal(1);
                    expect(composedDocument.sections[0].id).to.equal('a1bc');
                    done();
                });
            });
        });
    });

    it('Should be able to delete the only section', function(done) {
        socket.invoke('section.delete', {section_id: 'a1bc'}, function(results) {
            response = results[0];  // First listener

            expect(response.code).to.equal(200);

            // Check storage for only one section
            Delta.find({document: document._id}).exec(function(err, results) {
                expect(results.length).to.equal(8);

                delta = results[0];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('a1bc');
                expect(delta.args.index).to.equal(0);

                delta = results[1];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('x9da');
                expect(delta.args.index).to.equal(0);

                delta = results[2];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('cd15');
                expect(delta.args.index).to.equal(2);

                delta = results[3];

                expect(delta.name).to.equal('section.add');
                expect(delta.args.section_id).to.equal('h7af');
                expect(delta.args.index).to.equal(1);

                delta = results[4];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('h7af');

                delta = results[5];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('x9da');

                delta = results[6];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('cd15');

                delta = results[7];

                expect(delta.name).to.equal('section.delete');
                expect(delta.args.section_id).to.equal('a1bc');

                // Assert the resultant document
                Composer.compose(docid, 0, function(err, composedDocument) {
                    expect(composedDocument.sections.length).to.equal(0);
                    done();
                });
            });
        });
    });
});