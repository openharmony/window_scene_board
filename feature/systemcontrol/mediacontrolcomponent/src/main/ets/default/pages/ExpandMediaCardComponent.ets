/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { DropDownEvent, TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { ScreenOnOffEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { ViewType, viewMgrPolicy } from '@ohos/frameworkwrapper/src/main/ets/manager/view/ViewManagerPolicy';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { DefaultPanelZIndex } from '@ohos/systemuicommon/src/main/ets/base/common/info/DefaultPanelZIndex';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import Constants, { AVQueueInfo, ShowDevType, CastingSessionInfo } from '../Util/Constants';
import { ExpandMediaInfoCard } from './components/ExpandMediaInfoCard';
import { ExpandDevCard } from './components/ExpandDevCard';
import { ExpandHistoryCard } from './components/ExpandHistoryCard';
import { ExpandCallInfoCard } from './components/ExpandCallInfoCard';
import { LocalEventCallback } from '../Util/LocalEventCallBack';
import CommunicationUtil from '../Util/CommunicationUtil';
import {
  default as DropDownPanelManager,
  PanelDismissReason,
} from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import MediaInfoProvider from '../Controller/MediaInfoProvider';
import { MediaInfoProviderDc } from '../Controller/MediaInfoProviderDc';
import { DcMediaController } from '../Controller/DcMediaController';
import { CardMediaController } from '../Controller/CardMediaController';
import { CardMediaControllerDc } from '../Controller/CardMediaControllerDc';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import Curves from '@ohos.curves';
import AVSessionManager from '@ohos.multimedia.avsession';
import image from '@ohos.multimedia.image';

const TAG: string = 'ExpandMediaCardComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
// 系统弹框的是1902,为保证指纹验证功能正常，需要将播控中心层级临时调整1901，完成之后还原
const DROP_CONTROL_LEVEL: number = 1901;

@Component
export struct ExpandMediaCardComponent {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private scroller: Scroller = new Scroller();
  @State @Watch('showDevUpdate') showDeviceList: boolean = false; // 是否显示设备列表
  @State showDeviceAnim: boolean = false;
  @StorageLink('AlbumInfoList') @Watch('listChanged') albumInfoList: Array<AVQueueInfo> = [];
  @StorageLink('isPreferenceShow') isShowPrefer: boolean = false;
  private controller: CardMediaController | CardMediaControllerDc = this.enableDc ?
    CardMediaControllerDc.getInstance() : CardMediaController.getInstance(); // 开启worker时，使用DC子线程controller
  private mediaInfoProvider: MediaInfoProvider | MediaInfoProviderDc = this.enableDc ?
    MediaInfoProviderDc.getInstance() : MediaInfoProvider.getInstance();
  private dcController: DcMediaController | undefined = this.enableDc ? DcMediaController.getInstance() : undefined;
  private eventMgr: EventManager = EvtBus.createEventManager();
  @StorageLink('MediaEnable') hasMedia : boolean = false;
  @StorageLink('isSysColor') @Watch('onMediaThemeUsingChange') isSysColor: boolean = true;
  @State isAlbumListReady: boolean = false;
  @StorageLink('ControlMediaTitle') @Watch('isShowAllUpdate') title : string | boolean = '';
  @State isShowAll: boolean = !!this.hasMedia && !!this.title;
  @StorageLink('CurRemoteDevSelect') curRemoteOutputDev: number = -1;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  uiContext: UIContext = this.getUIContext();
  @Provide isJumping: boolean = false;
  @Provide isQuiting: boolean = false;
  @StorageLink('hasCall') @Watch('hasCallUpdated') hasCall: boolean = false;
  @State showDevType: ShowDevType = this.hasCall ? ShowDevType.CALL : ShowDevType.MEDIA;
  @StorageLink('sessionList') sessionList: Array<string> = [];
  @StorageLink('castingSessionInfo') @Watch('castSessionChange') castSession: CastingSessionInfo | undefined = undefined;
  private castSessionChangeCallback: LocalEventCallback | undefined = undefined;
  @State castBannerEffect: TransitionEffect = this.getCastBannerTransition(false);
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageLink('appIconMap') appIconMap: Map<string, image.PixelMap> = new Map();
  @State titleMaxFontScale: number = Constants.TITLE_MAX_FONT_SCALE;

  hasCallUpdated() {
    log.showInfo(`has call updated: ${this.hasCall}`);
    this.showDevType = this.hasCall ? ShowDevType.CALL : ShowDevType.MEDIA;
    this.castBannerEffect = this.getCastBannerTransition(this.hasCall, this.showDevType);
  }

  @StorageLink('isVerifyAccountShow') @Watch('onVerifyAccountShowChange') isVerifyAccountShow: boolean = false;
  onVerifyAccountShowChange() {
    log.showInfo(`onVerifyAccountShowChange,${this.isVerifyAccountShow}`);
    if (this.isVerifyAccountShow) {
      // 拉起注销服务是的密码验证弹框
      let viewController = viewMgrPolicy.getViewController(ViewType.DROPDOWN);
      viewController?.setZIndex(DROP_CONTROL_LEVEL);
    } else {
      // 密码验证弹框销毁的时候
      let viewController = viewMgrPolicy.getViewController(ViewType.DROPDOWN);
      viewController?.setZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
    }
  }
  /**
   * 下拉事件
   */
  @StorageLink('dropDownEvent') @Watch('onDropdownChanged') dropDownEvent: DropDownEvent =
    DropDownPanelManager.getDropDownEvent();
  lastTargetPanel: TargetPanel = TargetPanel.NONE; //缓存下拉目标面板
  /**
   * 下拉事件参数改变回调
   * 监听状态变化，0=TargetPanel.NONE，收起，2=控制中心
   */
  onDropdownChanged() {
    if (this.lastTargetPanel === this.dropDownEvent.target) {
      if (this.lastTargetPanel !== TargetPanel.CONTROL_CENTER_PANEL && this.isVerifyAccountShow) {
        this.isVerifyAccountShow = false;
      }
      return;
    }
    log.showInfo(`onDropdownChanged, targetChanged: last=${this.lastTargetPanel}, cur=${this.dropDownEvent.target}`);
    // 控制中心与通知中心切换
    if (this.lastTargetPanel !== TargetPanel.NONE && this.dropDownEvent.target !== TargetPanel.NONE) {
      this.lastTargetPanel = this.dropDownEvent.target;
      return;
    }
    this.lastTargetPanel = this.dropDownEvent.target;
    this.isVerifyAccountShow = false;
    this.controller.panelStateChange(this.dropDownEvent.target);
    // 关闭控制中心，清除历史歌单
    if (this.dropDownEvent.target === TargetPanel.NONE) {
      this.mediaInfoProvider.deleteAlbumInfoListLink();
      this.isAlbumListReady = false;
      return;
    }
    // 刷新数据
    this.showDeviceList = false; //每次下拉进入媒体卡，默认不显示设备列表
    this.mediaInfoProvider.getHistoricalAndRecommendData();
    this.mediaInfoProvider.isExistAvQueueStateUpdate();
  }

  aboutToAppear() {
    this.showDeviceList = false; //默认不显示设备列表
    log.showInfo(`ExpandControlCenterComponent aboutToAppear`);
    this.controller.doSubscribeNotify();
    this.controller.startShowing(TAG);
    this.eventMgr.on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
      AppStorage.setOrCreate('isCurScreenOn', event.isScreenOn());
      if (this.enableDc) {
        this.dcController?.setAppStorage('isCurScreenOn', event.isScreenOn());
      }
      log.showInfo(`onScreenOnOffEvent isCurScreenOn: ${event.isScreenOn()}`);
    });
    this.mediaInfoProvider.getHistoricalAndRecommendData();
    this.isVerifyAccountShow = false;
    this.castSessionChange();
    CommunicationUtil.addLocalEventListener('castSessionDeviceChange', this.getCastSessionCallback());
  }

  onMediaThemeUsingChange(): void {
    log.showInfo(`onMediaThemeUsingChange: ${this.isSysColor}`);
  }

  aboutToDisappear() {
    this.mediaInfoProvider.deleteAlbumInfoListLink();
    this.eventMgr.offAll();
    this.isAlbumListReady = false;
    this.mediaInfoProvider.clearCastSessionListener();
    CommunicationUtil.removeLocalEventListener('castSessionDeviceChange', this.getCastSessionCallback());
  }

  castSessionChange() {
    const hasCast: boolean = !!(this.castSession?.sessionId && this.sessionList.length > 0 &&
      this.castSession?.sessionId !== this.sessionList[0]);
    this.mediaInfoProvider.setCastSessionListener(hasCast, this.castSession?.sessionId);
  }

  getCastSessionCallback() {
    if (!this.castSessionChangeCallback) {
      this.castSessionChangeCallback = new LocalEventCallback((connectState: number) => {
        log.showInfo(`castSessionChangeCallback connectState = ${connectState}`)
        if (connectState === AVSessionManager.ConnectionState.STATE_DISCONNECTED) {
          this.castSession = undefined;
          if (this.enableDc) {
            this.dcController?.setAppStorage('castingSessionInfo', undefined);
          }
        }
      });
    }
    return this.castSessionChangeCallback;
  }

  listChanged() {
    log.showInfo('albumInfoList.length:' + this.albumInfoList?.length);
    if (this.albumInfoList?.length > 0 ) {
      this.isAlbumListReady = true;
      this.isShowAll = !!this.hasMedia && !!this.title; //更新是否有小边边
    } else {
      this.isAlbumListReady = false;
    }
  }

  showDevUpdate() {
    if (!this.showDeviceList) {
      this.isAlbumListReady = true;
      log.showInfo('albumInfoList.length:' + this.albumInfoList?.length);
      this.uiContext.animateTo({
        curve: Curves.interpolatingSpring(0, 1, 228, 25),
      }, () => {
        this.showDeviceAnim = false;
      })
    } else {
      this.uiContext.animateTo({
        curve: Curves.interpolatingSpring(0, 1, 228, 25),
      }, () => {
        this.showDeviceAnim = true;
      })
      this.isAlbumListReady = false; //歌单下树
    }
  }

  isShowAllUpdate( ) {
    if (this.title) {
      this.uiContext.animateTo({
        duration: 300,
        curve: Curves.interpolatingSpring(0, 1, 228, 25),
      }, () => {
        this.isShowAll = true;
      })
    }
  }

  /**
   * 是否显示投播快捷入口
   * @returns
   */
  isShowCastBanner() {
    return !!(this.castSession && this.sessionList.length > 0 &&
      this.castSession.sessionId !== this.sessionList[0]);
  }

  getCastBannerTransition(clickShowDev: boolean, showDevType?: ShowDevType): TransitionEffect{
    if (clickShowDev && this.hasCall) {
      let translateLength = showDevType === ShowDevType.CALL ? Constants.PANEL_EXPAND_HEIGHT_SMALL +
      Constants.CALL_CARD_EXPAND_HEIGHT : 0;
      return TransitionEffect.translate({y: translateLength})
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
        .combine(TransitionEffect.opacity(0)
          .animation({ duration: 150, curve: Curve.Sharp }))
        .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
    }
    return TransitionEffect.translate({ y: Constants.CAST_BANNER_HEIGHT / -2 })
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.opacity(0)
        .animation({ duration: 150, curve: Curve.Sharp }))
      .combine(TransitionEffect.rotate({ x: 1, angle: 60 })
        .animation({ duration: 250, curve: Curve.Friction }))
      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
  }

  @Builder castBanner() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      if (this.castSession && this.appIconMap[this.castSession.sessionId]) {
        Image(this.appIconMap[this.castSession.sessionId])
          .width(`${Constants.CAST_BANNER_IMG_SIZE}vp`)
          .height(`${Constants.CAST_BANNER_IMG_SIZE}vp`)
          .borderRadius(Constants.CAST_BANNER_IMG_BORDER_RADIUS)
          .draggable(false)
      }
      Row(){
        Text($r('app.string.av_cast_banner_title', this.castSession?.deviceName || ''))
          .fontColor($r('app.color.media_control_text_primary'))
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .fontWeight(FontWeight.Medium)
          .fontSize(16)
          .maxFontScale(this.titleMaxFontScale)
          .wordBreak(WordBreak.BREAK_ALL)
          .accessibilityLevel('yes')
          .accessibilityGroup(true)
          .maxLines(1)
          .textOverflow({overflow: TextOverflow.Ellipsis})
          .width('100%')
      }
      .width(`calc(100% - ${Constants.CAST_BANNER_ICON_WIDTH + Constants.CAST_BANNER_IMG_SIZE}vp)`)
      .padding({left: Constants.CAST_BANNER_TITLE_MARGIN, right: Constants.CAST_BANNER_TITLE_MARGIN})
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontSize(`${Constants.CAST_BANNER_ICON_SIZE}vp`)
        .backgroundColor(Constants.TRANSLUCENT_COLOR)
        .fontColor([$r('sys.color.icon_fourth')])
        .draggable(false)
        .width(`${Constants.CAST_BANNER_ICON_WIDTH}vp`)
    }
    .clip(true)
    .backgroundColor($r('app.color.media_control_card_bgc'))
    .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
    .borderRadius(Constants.MEDIA_CARD_LANDSCAPE_BORDER_RADIUS)
    .width(Constants.PANEL_EXPAND_WIDTH)
    .height(Constants.CAST_BANNER_HEIGHT)
    .padding(Constants.CAST_BANNER_PADDING)
    .margin({ top: Constants.CAST_BANNER_MARGIN_TOP})
    .onTouch((event?: TouchEvent) => {
      event?.stopPropagation();
    })
    .onClick(() => {
      if (this.castSession?.sessionId) {
        this.mediaInfoProvider.startAimApp(this.castSession.sessionId);
      }
    })
    .key('cast_banner')
    .zIndex(-1)
    .transition(this.castBannerEffect)
    .id('cast_banner')
  }

  build() {
    Column() {
      Stack() {
        Column() {
          Column() {
            Column()
              .width('100%')
              .key('top_margin_area_No.0')
            Column() {
              if (this.hasCall && (!this.showDeviceList || this.showDevType === ShowDevType.CALL)) {
                ExpandCallInfoCard({
                  isShowDev: $showDeviceList,
                  showDevType: $showDevType,
                  updateTransition: (clickShowDev: boolean, showDevType: ShowDevType) => {
                    this.castBannerEffect = this.getCastBannerTransition(clickShowDev, showDevType);
                  },
                })
              }
              Column() {
                Column() {
                  ExpandMediaInfoCard({
                    isShowDev: $showDeviceList,
                    showDevType: $showDevType,
                    isShowPrefer: $isShowPrefer,
                    updateTransition: (clickShowDev: boolean, showDevType: ShowDevType) => {
                      this.castBannerEffect = this.getCastBannerTransition(clickShowDev, showDevType);
                    },
                  })
                }
                .width('calc(100% - 20vp)')
                .padding({ top: this.hasCall && !this.showDeviceList ? Constants.CARD_EDGE_HALF_PADDING : 0 })
                .zIndex(2)

              Column() {
                if (this.isShowCastBanner() && !this.showDeviceList) {
                  this.castBanner()
                }
                if (this.showDeviceList) {
                  Column() {
                    ExpandDevCard({
                      isShowDev: $showDeviceList,
                      showDevType: $showDevType,
                    })
                  }
                  .scale({x : this.showDeviceAnim ? 1 : 0.65})
                  .opacity(this.showDeviceAnim ? 1 : 0 )
                  .rotate({
                    x: 1,
                    y: 0,
                    z: 0,
                    centerX: '50%',
                    centerY: '50%',
                    centerZ: 0,
                    angle: this.showDeviceAnim ? 0 : 60,
                  })
                }
                this.bottomBlankArea()
              }
                .clip(!this.hasCall || this.showDevType === ShowDevType.MEDIA)
                .width('calc(100% - 20vp)')
                .layoutWeight(1)
              }
              .clip(this.hasCall || this.showDevType === ShowDevType.CALL)
              .width('calc(100% + 20vp)')
              .layoutWeight(1)
            }
          }
          .width('100%')
          .constraintSize({ minHeight: '100%' })
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
        }
        .direction(Direction.Ltr)
        .width(Constants.PANEL_EXPAND_WIDTH)
        .height('100%')
        .alignItems(HorizontalAlign.Start)
        .clip(false)

      }
      .width('100%')
      .height('100%')
      .opacity(1)

    }
    .direction(Direction.Ltr)
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .opacity(1)
  }


  @Builder
  bottomBlankArea() {
    Column()
      .id('expand_media_card_bottom_blank_area')
      .layoutWeight(1)
      .width('100%')
      .gesture(
        GestureGroup(GestureMode.Exclusive,
          GestureGroup(GestureMode.Parallel,
            // 只接收上滑手势，屏蔽其它方向的滑动手势
            PanGesture({ direction: PanDirection.Up, distance: 15 })
              .onActionStart(event => {
                DropDownPanelManager.setDismissReason(PanelDismissReason.SLIDE_UP);
                DropDownPanelManager.animToDismiss();
              }),
            PanGesture({ direction: PanDirection.Down })
          ),
          TapGesture()
            .onAction((event?: GestureEvent) => {
              DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
              DropDownPanelManager.animToDismiss();
            })
        )
      )
      .focusable(false)
      .accessibilityLevel('no')
  }
}