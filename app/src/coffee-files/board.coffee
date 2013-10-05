define (require,exports,module)->
  Basic = require("coreDir/basic");
  Util = require("coreDir/util");
  Square = require("coreDir/square");
  #console.log('bosss')
  boardScope = null
  TZ.mymodule.factory("scope_finished",($q)->
    #
    deferred = $q.defer()
    deferred.promise.then(()->
      TZ.board.bind_scope_event()
    )
    return deferred
  )

  TZ.mymodule.controller("BoardCtrl",($scope, $routeParams,$q,$http,scope_finished)->
    # todo !!! how can angular know what kind of service I use regardless of order?
    TZ.scope_finished_defered = $q.defer()
    boardScope = $scope.$new(false)
    squareScope = $scope.$new(false)
    frameScope = $scope.$new(false)

    window.TZ.boardScope = boardScope
    window.TZ.squareScope = squareScope
    window.TZ.frameScope = frameScope

#    console.log(scope_finished)
    scope_finished.resolve()

    $scope.getTime = ()->
      return Date().toString()
    boardScope.$on("redraw",()->
      #console.log("board scope  -- redraw")

    )
  )
  #window.TZ.BoardCtrl = BoardCtrl #ugly hack...

  class Board extends Basic
    constructor:()->
      super(arguments)

      el=@
      TZ.board = el
    rDefault:
      # #蓝黄
      # fill:"#41bea8",
      # stroke:'none'

      # 黄色
#      fill:'#febe28'
      fill:'#febe28'
      stroke:'none'

    matrix : []
    boardScope: null
    refresh : (atbt,options)->
      @matrix = []
    rEle: null
    create : ()->
      el = @
      #@rEle = @rPaper.set()
      @rEle = @rPaper.rect(@offsetToSvg.x,@offsetToSvg.y,BOARD_SIZE.xGrids * BOARD_SIZE.gridWidth,BOARD_SIZE.yGrids * BOARD_SIZE.gridWidth).attr(@rDefault)

    bind_scope_event:()->
      el = @
      if not @boardScope
        @boardScope = window.TZ.boardScope
#      console.log(@rEle)
#      eve.on("board.click",null,(e)->
#        console.log("clicked")
#        try
#          el.boardScope.$emit("redraw")
#        catch e
#          console.log(e.message)
#      )
      @rEle.click((e)->
        el.click(e)
      )
    click:(e)->
      #console.log("board click")
      console.log(e)
      toBoard = {x: e.layerX,y: e.layerY}
      gridArg = Util.convert_board_to_model(toBoard,"layer")
      sqr = new Square(gridArg,true)
#            绑定给raphael的click函数
#      @rElmt.click((event)->
#        console.log(event)
#        mouseToSvg =  offsetX:event.offsetX, offsetY:event.offsetY
##                console.log(mouseToSvg)
#        el.click(mouseToSvg : mouseToSvg ,eventArg : event)
#      )
#
#    click : (args)->
#      point = args.mouseToSvg
#
#      if args.eventArg.shiftKey == true
#        #console.log('shift')
#        svgPos = getPointInGrid(x:point.offsetX, y:point.offsetY)
#        #tempSqr=new Tianzi.Square(svgPos)

  module.exports = Board
  return module.exports