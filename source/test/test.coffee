chai = require('chai')
expect = chai.expect
spies = require('chai-spies')

chai.use(spies)

{Datepicker, Momento, PubSub} = require '../javascripts/components/datepicker.js'


describe "Momento", ->
  it "should return false when the value is not valid", ->
    momento = new Momento()
    expect(momento.has_format("foo")).to.equal null
    expect(momento.has_format("00/00/0000")).to.equal null
    expect(momento.has_format("01/12/2012")).to.not.equal null

  it "should has the right format", ->
    momento = new Momento().has_format("01/12/2012")
    expect(momento).to.have.length(4)
    expect(momento).to.include "2012"
    expect(momento[1]).to.equal "01"
    expect(momento[2]).to.equal "12"
    expect(momento[3]).to.equal "2012"

    [complete, day, month, year] = momento
    expect(complete).to.equal "01/12/2012"
    expect(day).to.equal "01"
    expect(month).to.equal "12"
    expect(year).to.equal "2012"
  
  it "should be a valid date", ->
    momento = new Momento()
    expect(momento.has_format("01/12/2012")).to.be.ok
    expect(momento.has_format("01/12/2012")[0]).to.equal "01/12/2012"
    expect(momento.is_valid("01/12/2012")).to.be.true
    expect(momento.is_valid("29/02/2012")).to.be.true
    expect(momento.is_valid("29/02/2011")).to.be.false
    expect(momento.is_valid("1/1/2012")).to.be.true

  it "correct up date manipulation", ->
    momento = new Momento()
    momento.is_valid "24/11/2012"
    expect(momento.up()).to.equal "25/11/2012"
    expect(momento.up(2)).to.equal "26/11/2012"
    expect(momento.up(7)).to.equal "1/12/2012"

  it "correct down date manipulation", ->
    momento = new Momento()
    momento.is_valid "24/11/2012"
    expect(momento.down()).to.equal "23/11/2012"
    expect(momento.down(2)).to.equal "22/11/2012"
    expect(momento.down(24)).to.equal "31/10/2012"


describe "PubSub", ->
  it "correct instantiation", ->
    pubsub = new PubSub()
    expect(pubsub).to.respondTo('suscribe')
    expect(pubsub).to.respondTo('unsuscribe')
    expect(pubsub).to.respondTo('publish')
    expect(pubsub.events).to.exist

  it "correct suscription", ->
    pubsub = new PubSub()
    fn = (ev) ->
      console.log("fn")

    pubsub.suscribe('foo', fn)
    expect(pubsub.events.foo).to.exist
    expect(pubsub.events.foo.length).to.equal 1

    pubsub.suscribe('bar', fn)
    expect(pubsub.events.foo).to.exist
    expect(pubsub.events.bar).to.exist
    expect(pubsub.events.bar.length).to.equal 1

  it "correct suscription", ->
    pubsub = new PubSub()
    fn = (ev) ->
    fn2 = (ev) ->

    pubsub.suscribe('foo bar', fn)
    expect(pubsub.events.bar.length).to.equal 1
    expect(pubsub.events.foo.length).to.equal 1

    pubsub.suscribe('foo', fn2)
    expect(pubsub.events.foo.length).to.equal 2

  it "correct trigger events", ->
    pubsub = new PubSub()
    spy = chai.spy()
    pubsub.suscribe('event', spy)
    pubsub.publish('event')
    expect(spy).to.have.been.called

  it "correct trigger multiple events", ->
    pubsub = new PubSub()
    spy = chai.spy()
    pubsub.suscribe('some others', spy)
    pubsub.publish('some others')
    expect(spy).to.have.been.called.twice

describe "PubSub inheritance", ->
  it "correct extend functionality", ->
    datepicker = new Datepicker()
    expect(datepicker).to.respondTo 'suscribe'
    expect(datepicker).to.respondTo 'unsuscribe'
    expect(datepicker).to.respondTo 'publish'

  it "correct trigger multiple events", ->
    datepicker = new Datepicker()
    spy = chai.spy()
    datepicker.suscribe('event', spy)
    datepicker.publish('event')
    expect(spy).to.have.been.called.once
