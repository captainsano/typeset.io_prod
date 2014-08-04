var mongoose = require('mongoose');
var mockgoose = require('mockgoose');
mockgoose(mongoose);                     // Wrap mongoose with mockgoose

var socket = require('../mocks/socket');

var chai = require('chai');
var assert = chai.assert,
    expect = chai.expect,
    should = chai.should();

// Test the document handling
describe('Document Handling', function() {
    var Document;

    // Global Setup
    before(function() {
        require('../lib/doc')(socket, mongoose);
        Document = require('../lib/models/Document')(mongoose)
    });

    it('Should create a new document', function(done) {
        socket.invoke('doc.create', {title: 'My Own Document'}, function() {
            Document.findOne({title: 'My Own Document'}).exec(function(err, document) {
                if (!err) {
                    expect(document.title).to.equal('My Own Document');
                }
                done();
            });
        });
    });

    // TearDown
});