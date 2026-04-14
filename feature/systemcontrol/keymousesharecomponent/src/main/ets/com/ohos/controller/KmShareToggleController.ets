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

import { commonEventManager } from '@kit.BasicServicesKit';
import { pluginComponentManager } from '@kit.ArkUI';
import common from '@ohos.app.ability.common';
import rpc from '@ohos.rpc';
import { BusinessError } from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import {
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  GlobalContext,
  WallpaperChangeEvent
} from '@ohos/frameworkwrapper';
import { FASlotName } from '@ohos/commonconstants';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import Constants from '../common/Constants';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';

const TAG = 'Ctrl.KmShareToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class KmShareToggleController extends ToggleBaseViewModel {
  private stateSubscriber?: commonEventManager.CommonEventSubscriber;
  private mWallpaperAvgColor: string = '#00ffffff';
  private eventManager: EventManager = EvtBus.createEventManager();
  private rpcRemote?: rpc.IRemoteObject
  private retryConnectTimes: number = 0;

  public openDetailPageFunc: (() => void) = () => {
    if (this.getViewData().isUnavailable) {
      log.showWarn('click disabled');
      return;
    }
    this.resetRetryConnectTimes();
    this.connectProjectionService();
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.key_mouse_share');
    this.getViewData().icon = $r('sys.symbol.keymouse_sharing');
    this.onStart();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): KmShareToggleController {
    return SingletonHelper.getInstance(KmShareToggleController, TAG);
  };

  decorateStyle(style: ToggleStyle, scene?: ToggleScene | undefined): ToggleStyle | undefined {
    if (scene === ToggleScene.PC) {
      style.toggleParam?.labelArrow(true);
    }
    style.toggleParam?.isSymbolIcon(true)
      .symbolFontWeight(FontWeight.Medium)
      .symbolEffect(new PulseSymbolEffect())
    return style;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    this.subscribeCastConnectState();
    this.eventManager.on(WallpaperChangeEvent, (data: WallpaperChangeEvent) => {
      this.mWallpaperAvgColor = data.avgColor;
    });
  }

  updateIcon(): void {
    this.getViewData().icon = this.getViewData().isOn ? $r('sys.symbol.keymouse_sharing_fill') : $r('sys.symbol.keymouse_sharing');
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    this.unSubscribe();
    this.eventManager.offAll();
  }

  isAvailable(): boolean {
    return true;
  }

  handleOneClick(): void {
    log.showInfo('controlCenter kmShare click');
    this.openDetailPageFunc();
  }

  public reConnectService() {
    if (this.retryConnectTimes < Constants.MAX_RETRY_CONNECT_TIMES &&
      FASlotName.KEY_MOUSE_SHARE === sToggleSubWindowController.getCurrentSubPanelSlot()) {
      this.retryConnectTimes++;
      log.showInfo(`retry connect ${this.retryConnectTimes}`);
      this.connectProjectionService();
    }
  }

  public resetRetryConnectTimes(): void {
    this.retryConnectTimes = 0;
  }

  public closeRetryConnect(): void {
    this.retryConnectTimes = Constants.MAX_RETRY_CONNECT_TIMES;
  }

  private connectProjectionService(): void {
    if (this.rpcRemote) {
      log.showInfo('remote is not undefined');
      this.sendRemoteRequest();
      return;
    }
    let options: common.ConnectOptions = {
      onConnect(elementName, remote) {
        log.showInfo('onConnect callback');
        KmShareToggleController.getInstance().closeRetryConnect();
        KmShareToggleController.getInstance().rpcRemote = remote;
        KmShareToggleController.getInstance().sendRemoteRequest();
      },
      onDisconnect(elementName) {
        log.warn('onDisconnect castsourceservice');
        KmShareToggleController.getInstance().rpcRemote = undefined;
        KmShareToggleController.getInstance().changeConnectStatus(false);
        KmShareToggleController.getInstance().reConnectService();
      },
      onFailed(code) {
        log.warn(`onFailed castsourceservice callback ${code}}`);
        KmShareToggleController.getInstance().rpcRemote = undefined;
        KmShareToggleController.getInstance().reConnectService();
      }
    };
    let want: Want = {
      bundleName: 'com.openharmony.associateassistant',
      abilityName: 'KeyMouseService'
    }
    want.parameters = {
      wallpaperAvgColor: this.mWallpaperAvgColor
    }
    try {
      GlobalContext.getContext()?.connectServiceExtensionAbility(want, options);
    } catch (error) {
      log.showError(`kmshare connectServiceAbility error ${error.code}`);
    }
  }

  sendRemoteRequest(): void {
    let option = new rpc.MessageOption();
    let data = rpc.MessageSequence.create();
    data.writeInterfaceToken(Constants.KEY_MOUSE_SERVICE_DESCRIPTOR);
    data.writeString(this.mWallpaperAvgColor);
    let reply = rpc.MessageSequence.create();
    this.rpcRemote?.sendMessageRequest(Constants.CONTROL_CENTER_CLICK_CODE, data, reply, option)
      .then((result: rpc.RequestResult) => {
      log.warn(`sendMessageRequest result: ${result.code}`);
    })
      .catch((error: Error) => {
        log.showError(`kmshare sendMessageRequest error ${error.message}`);
      }).finally(() => {
      data.reclaim();
      reply.reclaim();
    });
  }

  private subscribeCastConnectState(): void {
    if (this.stateSubscriber) {
      log.showInfo('stateSubscriber is already subscribe');
      return;
    }
    // 订阅连接状态事件
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [Constants.PUBLISH_EVENT_CAST_CONNECTED, Constants.PUBLISH_EVENT_CAST_DISCONNECTED,
        Constants.PUBLISH_EVENT_CLOSE_SUB_WINDOW],
      publisherBundleName: 'com.openharmony.associateassistant'
    };
    // 创建订阅者回调
    commonEventManager.createSubscriber(subscribeInfo, (err: BusinessError, data) => {
      if (err) {
        log.showError(`createSubscriber error. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      log.showInfo('createSubscriber Succeeded');
      this.stateSubscriber = data;
      // 订阅公共事件回调
      if (this.stateSubscriber) {
        this.subscribeConnectStatus();
        this.publishCommonEvent(Constants.PUBLISH_EVENT_GET_CONNECT_STATE);
      } else {
        log.showError('subscriber is undefined');
      }
    });
  }

  private subscribeConnectStatus(): void {
    if (!this.stateSubscriber) {
      log.warn('subscribeConnectStatus subscriber is undefined, to create');
      this.subscribeCastConnectState();
      return;
    }
    try {
      commonEventManager.subscribe(this.stateSubscriber, (err: BusinessError, data) => {
        if (err) {
          log.showError(`subscribe error. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(`event: ${data.event}`);
        this.closeRetryConnect();
        if (data.event === Constants.PUBLISH_EVENT_CAST_CONNECTED) {
          this.changeConnectStatus(true);
        } else if (data.event === Constants.PUBLISH_EVENT_CAST_DISCONNECTED) {
          this.changeConnectStatus(false);
        } else if (data.event === Constants.PUBLISH_EVENT_CLOSE_SUB_WINDOW) {
          sToggleSubWindowController.hideWindow();
        } else {
          log.showError(`uninvalid event. event is ${data.event}`);
        }
      });
    } catch (error) {
      log.showError(`subscribe error: ${error}`);
    }
  }

  changeConnectStatus(isOpen: boolean): void {
    this.getViewData().isOn = isOpen;
    this.updateIcon();
    this.setStatusBarVisible(isOpen);
  }

  private unSubscribe(): void {
    if (!this.stateSubscriber) {
      log.warn('unSubscribe but stateSubscriber is undefined');
      return;
    }
    try {
      commonEventManager.unsubscribe(this.stateSubscriber, (err: BusinessError) => {
        if (err) {
          log.showError(`unsubscribe failed, code is ${err.code}, message is ${err.message}`);
        } else {
          this.stateSubscriber = undefined;
          log.showInfo('unsubscribe success');
        }
      });
    } catch (error) {
      this.stateSubscriber = undefined;
      let err: BusinessError = error as BusinessError;
      log.showError(`unsubscribe failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  private setStatusBarVisible(isVisible: boolean): void {
    pluginComponentManager.push({
      owner: {
        bundleName: 'com.ohos.sceneboard'
      },
      target: {
        bundleName: 'com.openharmony.associateassistant'
      },
      name: 'components/pages/plugin/PluginPcIcon.js',
      data: {},
      extraData: {
        requestVisible: isVisible
      }
    }, () => {
      log.showInfo(`push complete isVisible: ${isVisible}`);
    });
  }

  public updateDisableState(): void {
    if (this.isSatelliteMode) {
      this.getViewData().isUnavailable = true;
      return;
    }
    this.getViewData().isUnavailable = false;
  }

  private publishCommonEvent(event: string) {
    log.showInfo(`publishCommonEvent ${event}`);
    try {
      commonEventManager.publish(event, {
        bundleName: Constants.KEYMOUSE_SHARE_BUNDLE_NAME
      }, (err: BusinessError) => {
        if (err) {
          log.showError(`publishCommonEvent error code: ${err.code}`);
        }
      });
    } catch (error) {
      log.showError(`publishCommonEvent publish error code: ${error.code}`);
    }
  }
}