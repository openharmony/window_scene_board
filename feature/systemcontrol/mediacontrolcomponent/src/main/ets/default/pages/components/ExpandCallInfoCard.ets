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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import audio from '@ohos.multimedia.audio';
import Curves from '@ohos.curves';
import { DcMediaController } from '../../Controller/DcMediaController';
import { CardMediaControllerDc } from '../../Controller/CardMediaControllerDc';
import { CardMediaController } from '../../Controller/CardMediaController';
import { CallInfoCard } from './CallInfoCard';
import Constants, {
  ShowDevType,
  LocalDeviceInfo,
  DeviceSource,
} from '../../Util/Constants';
import { globalStorage } from '../../Util/GlobalStorage';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { WindowEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';

const TAG: string = 'ExpandCallInfoCard_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export struct ExpandCallInfoCard {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private controller: CardMediaController | CardMediaControllerDc = this.enableDc ?
    CardMediaControllerDc.getInstance() : CardMediaController.getInstance(); // 开启worker时，使用DC子线程controller
  private dcController: DcMediaController | undefined = this.enableDc ? DcMediaController.getInstance() : undefined;
  private uiContext: UIContext = this.getUIContext();
  private eventMgr: EventManager = EvtBus.createEventManager();
  @Link isShowDev: boolean;
  @Link showDevType: ShowDevType;
  @State textMaxFontScale: number = Constants.TEXT_MAX_FONT_SCALE;
  @State titleMaxFontScale: number = Constants.TITLE_MAX_FONT_SCALE;
  @State callTimerId: number | undefined = undefined;
  @State pointOpacityFirst: number = 0.1;
  @State pointOpacitySecond: number = 0.1;
  @State pointOpacityThird: number = 0.1;
  @State isButtonHolding: boolean = false;
  @State fadeOpacity: number = 1;
  @State callCardWidth: number = Constants.PANEL_EXPAND_WIDTH;
  @State callCardHeight: number = Constants.CALL_CARD_EXPAND_HEIGHT;
  @StorageLink('CurSessionId') private curSessionId: string = '';
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @StorageLink('curCallDevice') @Watch('callStateUpdate') curCallDevice: LocalDeviceInfo = {
    deviceType: audio.DeviceType.SPEAKER,
    deviceId: 0,
    deviceName: 'xxx',
    deviceSource: DeviceSource.LOCAL,
    networkId: 'LocalDevice',
  };
  public updateTransition: (clickShowDev: boolean, showDevType: ShowDevType) => void =
    (clickShowDev: boolean, showDevType: ShowDevType) => {};

  aboutToAppear() {
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      // 隐藏控制中心
      if (event.windowName === 'SysUI_Dropdown' && event.eventType === WindowEvent.EVENT_TYPE_HIDE &&
        this.callTimerId !== undefined) {
        clearInterval(this.callTimerId);
        this.callTimerId = undefined;
        this.pointOpacityFirst = 0.1;
        this.pointOpacitySecond = 0.1;
        this.pointOpacityThird = 0.1;
      }
    });
  }

  aboutToDisappear() {
    this.eventMgr.offAll();
    if (this.callTimerId !== undefined) {
      clearInterval(this.callTimerId);
      this.callTimerId = undefined;
    }
  }

  callStateUpdate() {
    if (this.curCallDevice.deviceType === audio.DeviceType.SPEAKER ||
      this.curCallDevice.deviceType === audio.DeviceType.EARPIECE) {
      if (this.callTimerId !== undefined) {
        clearInterval(this.callTimerId);
        this.callTimerId = undefined;
      }
      this.pointOpacityFirst = 0.1
      this.pointOpacitySecond = 0.1;
      this.pointOpacityThird = 0.1;
      return;
    }
    if (this.callTimerId === undefined) {
      this.callTimerId = setInterval(() => {
        this.pointOpacityFirstAnim();
        this.pointOpacitySecondAnim();
        this.pointOpacityThirdAnim();
      }, Constants.POINT_ANIMATION_INTERVAL);
    }
  }

  pointOpacityFirstAnim() {
    this.uiContext.animateTo({
      duration: 250, // 动画时长
      curve: Curve.Linear, // 动画曲线
      delay: 0, // 动画延迟
      playMode: PlayMode.Normal // 动画模式
    }, () => {
      this.pointOpacityFirst = 0.4;
    })
    this.uiContext.animateTo({
      duration: 450,
      curve: Curve.Linear,
      delay: 250,
      playMode: PlayMode.Normal
    }, () => {
      this.pointOpacityFirst = 0.2;
    })
    this.uiContext.animateTo({
      duration: 600,
      curve: Curve.Linear,
      delay: 700,
      playMode: PlayMode.Normal
    }, () => {
      this.pointOpacityFirst = 0.1;
    })
  }

  /**
   * 播放时，标题行动画-2
   */
  pointOpacitySecondAnim() {
    this.uiContext.animateTo({
      duration: 350,
      curve: Curve.Linear,
      delay: 100,
      playMode: PlayMode.Normal
    }, () => {
      this.pointOpacitySecond = 0.4;
    })
    this.uiContext.animateTo({
      duration: 450,
      curve: Curve.Linear,
      delay: 450,
      playMode: PlayMode.Normal
    }, () => {
      this.pointOpacitySecond = 0.2;
    })
    this.uiContext.animateTo({
      duration: 400,
      curve: Curve.Linear,
      delay: 900,
      playMode: PlayMode.Normal
    }, () => {
      this.pointOpacitySecond = 0.1;
    })
  }

  pointOpacityThirdAnim() {
    this.uiContext.animateTo({
      duration: 450,
      curve: Curve.Linear,
      delay: 250,
      playMode: PlayMode.Normal
    }, () => {
      this.pointOpacityThird = 0.4;
    })
    this.uiContext.animateTo({
      duration: 350,
      curve: Curve.Linear,
      delay: 750,
      playMode: PlayMode.Normal
    }, () => {
      this.pointOpacityThird = 0.2;
    })
    this.uiContext.animateTo({
      duration: 250,
      curve: Curve.Linear,
      delay: 1050,
      playMode: PlayMode.Normal
    }, () => {
      this.pointOpacityThird = 0.1;
    })
  }

  //点击投播按钮
  clickSwitchIcon() {
    let startTime = new Date().getTime();
    this.showDevType = ShowDevType.CALL;
    this.updateTransition(true, this.showDevType);
    this.uiContext.animateTo({
      curve: Curve.Friction,
      duration: 333,
      onFinish: () => {
        if (this.isShowDev) {
          this.controller.reportExpandShowDeviceList(this.curSessionId, startTime);
        }
      }
    }, () => {
      log.showInfo('click call device list button');
      this.isShowDev = !this.isShowDev;
      globalStorage.setNumberByKey('isShowSwitch', this.isShowDev ? 0 : 1);
      if (this.enableDc) {
        this.dcController?.callGlobalStorage({name: 'isShowSwitch', value: this.isShowDev ? 0 : 1});
      }
    });
  }

  getCallCardTransition(): TransitionEffect {
    return TransitionEffect.translate({y: Constants.CARD_EDGE_HALF_PADDING * 2 - this.callCardHeight})
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.opacity(0)
        .animation({ duration: 150, curve: Curve.Sharp }))
      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
  }

  build(){
    Column() {
      CallInfoCard({
        isLandscape: this.isLandscape,
        panelWidth: this.callCardWidth,
        panelHeight: this.callCardHeight,
        fadeOpacity: this.fadeOpacity,
        textMaxFontScale: this.textMaxFontScale,
        pointOpacityFirst: this.pointOpacityFirst,
        pointOpacitySecond: this.pointOpacitySecond,
        pointOpacityThird: this.pointOpacityThird,
        curCallDevice: this.curCallDevice,
        dcController: this.dcController,
        isButtonHolding: $isButtonHolding,
        showVolume: false,
        clickCurSwitchIcon: () => {
          this.clickSwitchIcon();
        }
      })
        .onTouch((event: TouchEvent) => {
          if (this.isButtonHolding || event?.type !== TouchType.Up) {
            return;
          }
        })
    }
    .width(this.callCardWidth)
    .transition(this.getCallCardTransition())
    .key('call_card')
  }
}