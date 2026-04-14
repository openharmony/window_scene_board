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
import { DeviceListCard } from './DeviceListCard';
import Constants, {
  DeviceSource,
  LocalDeviceInfo,
  ShowDevType,
  CallSessionInfo,
} from '../../Util/Constants';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import audio from '@ohos.multimedia.audio';
import MeasuringUtil from '../../Util/MeasuringUtil';
import { DcMediaController } from '../../Controller/DcMediaController';
import { CastDeviceControl } from '../../Controller/CastDeviceControl';
import { CastDeviceControlDc } from '../../Controller/CastDeviceControlDc';
import { globalStorage } from '../../Util/GlobalStorage';
import { LocalEventCallback } from '../../Util/LocalEventCallBack';
import CommunicationUtil from '../../Util/CommunicationUtil';
import { JSON } from '@kit.ArkTS';
import Curves from '@ohos.curves';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const TAG: string = 'ExpandDevCard_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export struct ExpandDevCard {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private dcController: DcMediaController | undefined = this.enableDc ? DcMediaController.getInstance() : undefined;
  private audioRoutingManager = audio.getAudioManager().getRoutingManager();
  private scroller: Scroller = new Scroller();
  @Link @Watch('isShowDevUpdate') isShowDev: boolean;
  @StorageLink('CurSessionId') @Watch('curSessionIdChanged') private curSessionId: string = '';
  @StorageLink('sessionList') @Watch('onSessionListUpdated') sessionList: Array<string> = [];
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  // 本机默认高度 + 上下padding
  @State deviceListHeight: number = Constants.DEVICE_ITEM_HEIGHT + Constants.DEVICE_LIST_BOTH_PADDING;
  @State callDeviceListHeight: number = Constants.DEVICE_ITEM_HEIGHT + Constants.DEVICE_LIST_BOTH_PADDING;
  @StorageLink('CurDeviceSelect') curOutputDevice: LocalDeviceInfo ={
    deviceType: audio.DeviceType.SPEAKER,
    deviceId: 0,
    deviceName: 'xxx',
    deviceSource: DeviceSource.LOCAL,
    networkId: 'LocalDevice',
  };
  @StorageLink('MergedDeviceList') @Watch('onDevicesUpdated') mergedDeviceList: Array<LocalDeviceInfo> = [];
  @StorageLink('curCallDevice') curCallDevice: LocalDeviceInfo = {
    deviceType: audio.DeviceType.SPEAKER,
    deviceId: 0,
    deviceName: 'xxx',
    deviceSource: DeviceSource.LOCAL,
    networkId: 'LocalDevice',
  };
  @StorageLink('callDeviceList') @Watch('onDevicesUpdated') callDeviceList: Array<LocalDeviceInfo> = [];
  @StorageLink('callSessionInfo') callSession: CallSessionInfo | undefined = undefined;
  @Link showDevType: ShowDevType;
  @State private castDeviceControl: CastDeviceControl | CastDeviceControlDc | undefined = undefined;
  @State private displayDeviceList: Array<LocalDeviceInfo> = []; // 可信设备列表
  @State isExpand: boolean = false; // 控制是否展开非可信设备列表
  @State hideDeviceScroll: boolean = false; // 是否隐藏设备列表滚动条
  @State deviceDisable: boolean = false;
  @State curForceMedia: number = 0;
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  // 设备列表透明度
  @State deviceListOpacity: number = 0;
  private coldStartDoneCallback: LocalEventCallback | undefined = undefined;

  getColdStartDoneCallback(): LocalEventCallback {
    if (!this.coldStartDoneCallback) {
      this.coldStartDoneCallback = new LocalEventCallback(() => {
        log.showInfo(`start discovery on cold start done: ${this.curSessionId?.length < 10 ? '' :
          (this.curSessionId?.substr(0, 5) + '**' + this.curSessionId?.substr(this.curSessionId?.length - 5))}`);
        if (this.curSessionId) {
          this.castDeviceControl?.startControl(this.curSessionId);
        }
      });
    }
    return this.coldStartDoneCallback;
  }

  /**
   * 当前sessionId变化
   */
  async curSessionIdChanged() {
    log.showInfo(`session id changed: ${this.curSessionId?.length < 10 ? '' : (this.curSessionId?.substr(0, 5) + '**' +
    this.curSessionId?.substr(this.curSessionId?.length - 5))}, ${this.isShowDev}`)
    if (globalStorage.getBooleanByKey('isColdStarting')) {
      log.warn('do not start discovery while cold starting')
      return;
    }
    this.castDeviceControl?.startControl(this.curSessionId);
  }
  /**
   * 设备列表变更
   */
  onDevicesUpdated(): void {
    this.displayDeviceList = this.mergedDeviceList?.filter((device: LocalDeviceInfo) => {
      return device?.authenticationStatus === 1;
    }) || [];
    const displayCount = this.displayDeviceList.length || 1;
    const count = this.isExpand ? displayCount : displayCount;
    // padding不参与大字体计算
    let deviceListHeight =
      count * MeasuringUtil.getHeight(16, Constants.PANEL_LIST_ITEM_CONTENT_HEIGHT, 2, this.getFontSizeScale());
    deviceListHeight += Constants.DEVICE_LIST_BOTH_PADDING;
    this.deviceListHeight = deviceListHeight > Constants.DEVICE_LIST_MAX_HEIGHT ?
    Constants.DEVICE_LIST_MAX_HEIGHT : deviceListHeight;
    log.showInfo(`update deviceList length ${count}`);

    // 通话设备列表
    const callDisplayCount = this.callDeviceList.length || 1;
    let callDeviceListHeight = callDisplayCount * MeasuringUtil.getHeight(16,
      Constants.PANEL_LIST_ITEM_CONTENT_HEIGHT, 2, this.getFontSizeScale());
    this.callDeviceListHeight = callDeviceListHeight > Constants.DEVICE_LIST_MAX_HEIGHT ?
      Constants.DEVICE_LIST_MAX_HEIGHT : callDeviceListHeight;
    log.showInfo(`update callDeviceList length ${callDisplayCount}`);
  }

  isShowDevUpdate() {
    if (this.isShowDev) {
      this.castDeviceControl = this.enableDc ? CastDeviceControlDc.getInstance() : CastDeviceControl.getInstance();
      this.castDeviceControl?.startControl(this.curSessionId);
      this.initDeviceList();
      this.deviceDisable = false;
    }
  }
  aboutToDisappear() {
    this.castDeviceControl = undefined;
    CommunicationUtil.removeLocalEventListener('coldStartDone', this.getColdStartDoneCallback());
    try {
      this.audioRoutingManager.off('deviceChange', this.deviceChangeCallback);
    } catch (err) {
      log.showError(`Faild to off deviceChange. Code: ${err.code}, message: ${err.message}`);
    }
  }

  aboutToAppear() {
    CommunicationUtil.addLocalEventListener('coldStartDone', this.getColdStartDoneCallback());
    if (this.sessionList.length > 0) {
      this.curSessionId = this.sessionList[0];
      if (this.enableDc) {
        this.dcController?.setAppStorage('CurSessionId', this.sessionList[0]);
      }
    }
    this.deviceListHeight = MeasuringUtil.getHeight(16, this.deviceListHeight, 2, this.getFontSizeScale());
    this.callDeviceListHeight = MeasuringUtil.getHeight(16, this.deviceListHeight, 2, this.getFontSizeScale());
    try {
      this.audioRoutingManager.on('deviceChange', audio.DeviceFlag.OUTPUT_DEVICES_FLAG, this.deviceChangeCallback);
    } catch (err) {
      log.showError(`Faild to on deviceChange. Code: ${err.code}, message: ${err.message}`);
    }
    this.castDeviceControl = this.enableDc ? CastDeviceControlDc.getInstance() : CastDeviceControl.getInstance();
    this.castDeviceControl?.startControl(this.curSessionId);
    this.initDeviceList();
    this.deviceDisable = false;
  }

  private deviceChangeCallback = (deviceChanged: audio.DeviceChangeAction) => {
    log.showInfo(`device change type:${JSON.stringify(deviceChanged.type)}`);
    if (!this) {
      log.showInfo(`this has been destroyed`);
      return;
    }
    this.castDeviceControl = this.enableDc ? CastDeviceControlDc.getInstance() : CastDeviceControl.getInstance();
    this.castDeviceControl?.startControl(this.curSessionId);
  }

  /**
   * sessionList变更
   */
  async onSessionListUpdated() {
    if (!this.sessionList || this.sessionList.length <= 0) {
      log.showError(`session list is not exit`);
      return;
    }
    if (this.curForceMedia >= this.sessionList.length) {
      log.showInfo(`session list updated meet outside forceNum: ${this.curForceMedia}`);
      let sessionIndex = this.sessionList.indexOf(this.curSessionId);
      this.curForceMedia = sessionIndex < 0 ? 0 : sessionIndex;
    }
    this.curSessionId = this.sessionList[this.curForceMedia];
  }

  initDeviceList() {
    if (this.isShowDev) {
      this.uiContext.animateTo({
        duration: 333,
        curve: Curve.Friction
      }, () => {
        this.deviceListOpacity = 1;
      })
    } else {
      this.deviceListOpacity = 1;
    }
  }

  getFontSizeScale() {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.sysConfigData?.fontSizeScale || 1;
    } else {
      return ResourceVm.instance.fontScale;
    }
  }

  getDeviceCardTransition(): TransitionEffect {
    let translateLength: number = this.showDevType === ShowDevType.CALL ?
      this.callDeviceListHeight + Constants.HIS_CARD_HEIGHT + Constants.PANEL_EXPAND_HEIGHT_SMALL :
      this.deviceListHeight + Constants.HIS_CARD_HEIGHT;
    return TransitionEffect.translate({ y: translateLength * -1 })
      .animation({curve: Curves.interpolatingSpring(0, 1, 228, 25)})
      .combine(TransitionEffect.opacity(0)
        .animation({ duration: 150, curve: Curve.Linear, delay: 83 }))
      .combine(TransitionEffect.rotate({ x: 1, angle: 60 })
        .animation({ duration: 250, curve: Curve.Friction}))
      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25)}))
  }

  @Builder deviceList(showDevType: ShowDevType) {
      // 设备列表的代码
      Column() {
        Scroll(this.scroller) {
          DeviceListCard({
            prefix: 'merged',
            selectMode: 'checkbox',
            curOutputDev: showDevType === ShowDevType.CALL ? this.curCallDevice : this.curOutputDevice,
            deviceList: showDevType === ShowDevType.CALL ? this.callDeviceList : this.displayDeviceList,
            showDevType: showDevType,
            isExpand: $isExpand, //展开非可信设备列表
            hideDeviceScroll: $hideDeviceScroll,
            dsControl: $castDeviceControl,
            dcController: this.dcController,
            deviceDisable: $deviceDisable,
            curSessionId: showDevType === ShowDevType.CALL ?
              (this.callSession?.sessionId || '') : this.curSessionId,
          })
            .width('100%')
        }
        .borderRadius(Constants.DEVICE_LIST_SCROLL_RADIUS)
        .constraintSize({
          maxHeight: Constants.EXPAND_DEVICE_LIST_MAX_HEIGHT
        })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          let listHeight = Number(newValue.height);
          listHeight = listHeight > Constants.DEVICE_LIST_MAX_HEIGHT ?
            Constants.DEVICE_LIST_MAX_HEIGHT : listHeight;
          if (listHeight === 0) {
            return;
          }
          if (this.showDevType === ShowDevType.CALL && this.callDeviceListHeight !== listHeight) {
            log.showInfo(`call device list area change: ${listHeight}`);
            this.callDeviceListHeight = listHeight;
          } else if (this.showDevType === ShowDevType.MEDIA && this.deviceListHeight !== listHeight) {
            log.showInfo(`device list area change: ${listHeight}`);
            this.deviceListHeight = listHeight;
          }
        })
      }
      .backgroundColor($r('app.color.media_control_card_bgc'))
      .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
      .saturate(1)
      .shadow({ radius : 0})
      .backdropBlur(undefined)
      .border({
        width:  0,
        color: '#00000000',
      })
      .borderRadius(Constants.MEDIA_CARD_LANDSCAPE_BORDER_RADIUS)
      .clip(Constants.SECOND_PANEL_CLIP)
      .width(Constants.PANEL_EXPAND_WIDTH)
      .margin({ top: 16 })
      .transition(this.getDeviceCardTransition())
      .key('device_expand_card')
  }

  build() {
    Column() {
      if (this.isShowDev && this.showDevType === ShowDevType.CALL) {
        this.deviceList(ShowDevType.CALL)
      } else if (this.isShowDev && this.showDevType === ShowDevType.MEDIA) {
        this.deviceList(ShowDevType.MEDIA)
      }
    }
    .width(Constants.PANEL_EXPAND_WIDTH)
    .opacity((this.isShowDev ? this.deviceListOpacity : 0))
    .onTouch((event?: TouchEvent) => {
      event?.stopPropagation();
    })
  }
}
