var mongoose = require('mongoose');
var mockgoose = require('mockgoose');
mockgoose(mongoose);                     // Wrap mongoose with mockgoose

var socket = require('../mocks/socket');

var chai = require('chai');
var assert = chai.assert,
    expect = chai.expect,
    should = chai.should();

// Test the document handling
// NOTE: The below test are to be executed in sequence
describe('Document Handling', function() {
    var Document, documentID;

    // Global Setup
    before(function() {
        require('../lib/doc')(socket, mongoose);
        Document = require('../lib/models/Document')(mongoose);
    });

    it('Should create a new document', function(done) {
        socket.invoke('doc.create', {name: 'My Own Document'}, function(results) {
            response = results[0];  // Evaluate the first listener

            // Evaluate the response
            expect(response.code).to.equal(200);
            expect(response.data.name).to.equal('My Own Document');

            // Check the the storage
            Document.findOne({name: 'My Own Document'}).exec(function(err, document) {
                if (!err) {
                    expect(document.name).to.equal('My Own Document');
                }
                done();
            });
        });
    });

    it('Should be able to list the documents', function(done) {
        socket.invoke('doc.list', {}, function(results) {
            response = results[0];     // Evaluate the first listener

            // Evaluate the response
            expect(response.code).to.equal(200);
            docs = response.data;

            expect(docs[0].name).to.equal('My Own Document');

            documentID = docs[0].id;   // Capture the id for the next test
            done();
        });
    });

    it('Should be able to rename a document', function(done) {
        socket.invoke('doc.rename', {id: documentID, name: 'Renamed'}, function(results) {
            response = results[0];      // Evaluate the first listener

            // Evaluate the response
            expect(response.code).to.equal(200);

            // Check the database
            Document.findOne({name: 'Renamed'}).exec(function(err, document) {
                expect(document._id.toString()).to.equal(documentID);
                done();
            });
        });
    });

    it('Should be able delete a document', function(done) {
        socket.invoke('doc.delete', {id: documentID}, function(results) {
            response = results[0];

            // Evaluate the response
            expect(response.code).to.equal(200);

            // Check the storage
            Document.find({name: 'Renamed'}).exec(function(err, document) {
                expect(document).to.be.empty;
                done();
            });
        });
    });

    // TODO: Add tests for negative cases

    // TearDown
});