/*
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import audio from '@ohos.multimedia.audio';
import BusinessError from '@ohos.base';
// import collaborationServiceManager from '@hms.collaboration.collaborationServiceManager'
import Constants, { DeviceSource, CarInfo, AudioControlCode, WorkerMsgCastParameter} from '../Util/Constants';
import CastDeviceManager from './CastDeviceManager';
import promptAction from '@ohos.promptAction';
import SessionInfoProvider from './SessionInfoProvider';
import { RadarParam } from '../Util/CommonInterface';
import { EventType, HiSysEvent, BizScene, BizState, StageResult, TriggerMode, DiscoverDeviceList }
  from '../Util/HiSysEvent';
import { access } from '@kit.ConnectivityKit';
import { CollaborationCallBack, CollaborationRegisterManager } from './CollaborationRegisterManager';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';

const TAG: string = 'CastDeviceControl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const radarBunldName = 'ohos.mediacontroller';

export class CastDeviceControl {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private startDoneLink: AbstractProperty<boolean> = AppStorage.setAndRef('StartDone', false);
  private isSelectingClickLink: AbstractProperty<boolean> = AppStorage.setAndRef('isSelectingClick', false);
  public static deviceManager: CastDeviceManager | undefined;
  // private serviceStateMapLink: AbstractProperty<Map<string, collaborationServiceManager.State>>;
  private audioManager: audio.AudioManager;
  private targetSessionId: string = '';
  public static controller: CastDeviceControl | undefined = undefined;

  constructor() {
    log.showInfo(' do storageLink init task done ');
    this.audioManager = audio.getAudioManager();
    // let serviceStateMap: Map<string, collaborationServiceManager.State> =
    //   new Map<string, collaborationServiceManager.State>();
    // this.serviceStateMapLink = AppStorage.setAndRef('serviceStateMap', serviceStateMap);
  }

  public static getInstance(): CastDeviceControl {
    log.showInfo(`card device control getInstance: ${!CastDeviceControl.controller}`);
    if (!CastDeviceControl.controller) {
      log.showInfo('first init card media controller');
      CastDeviceControl.controller = new CastDeviceControl();
      CastDeviceControl.controller.initWorker();
    }
    if (CastDeviceControl.controller && CastDeviceControl.deviceManager === undefined) {
      log.showInfo('retry init storage link');
      CastDeviceControl.deviceManager = new CastDeviceManager();
    }
    return CastDeviceControl.controller;
  }

  /**
   * 子线程初始化
   */
  initWorker() {
    if (!this.enableDc) {
      return;
    }
    log.showInfo(`init worker: ${TAG}`);
    messageChannel.onMessage(Constants.ASYNC_CAST_DEVICE_CONTROL, this.callByWorker); // 监听子线程消息
  }

  /**
   * 子线程调用方法，统一处理异步函数
   */
  private callByWorker = (parameter: WorkerMsgCastParameter) => {
    if (parameter.type !== undefined) {
      this.callOperation[parameter.type]?.(parameter);
    }
  }

  /**
   * 响应子线程操作回调，使用字面量对象优化switch case
   */
  private callOperation: Record<string, (parameter: WorkerMsgCastParameter) => void> = {
    'selectDevice': (parameter: WorkerMsgCastParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.selectDevId !== undefined &&
        parameter?.isCall !== undefined) {
        this.selectDevice(parameter?.selectDevId, parameter?.sessionId, parameter?.isCall);
      }
    },
    'release': (parameter: WorkerMsgCastParameter) => {
      this.release();
    },
    'outOutDeviceChangeEvent': (parameter: WorkerMsgCastParameter) => {
      CastDeviceControl.deviceManager?.getLocalDeviceListOnce();
    },
  }

  /**
   * control start init
   */
  async startControl(sessionId: string, bundleName?: string) : Promise<string> {
    log.showInfo(`startControls: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}, ${bundleName}`);
    this.targetSessionId = sessionId;
    if (!sessionId && bundleName) {
      log.showInfo(`try find sessionId with bundleName: ${bundleName}`);
      const provider = await SessionInfoProvider.getInstance();
      const descriptor = provider.findSessionWithBundleName(bundleName);
      if (descriptor !== null) {
        this.targetSessionId = descriptor.sessionId;
      }
    }
    this.startDeviceDiscovery(this.targetSessionId, !!bundleName);
    this.startDoneLink.set(true);
    log.showInfo('startControls done');
    return this.targetSessionId;
  }

  /**
   * init routing manager and listen device change event
   */
  startDeviceDiscovery(sessionId: string, isFromPanel = false) {
    if (!CastDeviceControl.deviceManager) {
      return;
    }
    log.showInfo(`start startDeviceDiscovery`);
    let radarParam : RadarParam = { // 开始搜索设备 雷达打点
      ORG_PKG: radarBunldName,
      TO_CALL_PKG: 'av_session',
      TRIGGER_MODE: AppStorage.get('selectMode') === 'checkbox' ?
        TriggerMode.mediaDeviceListCast : TriggerMode.appComponentCast,
      FUNC: 'startDeviceDiscovery',
      BIZ_SCENE: BizScene.discoverDevice,
      BIZ_STAGE: DiscoverDeviceList.startSearchDevice,
      STAGE_RES: StageResult.idle,
      BIZ_STATE: BizState.start
    };
    HiSysEvent.getEventParam(EventType.MEDIA_CONTROL_CAST_BEHAVIOR).updateAllExtendParam(radarParam).reportEvent(false);
    CastDeviceControl.deviceManager?.start(sessionId, isFromPanel)
      .then(data => {
        log.showInfo(`start success: ${JSON.stringify(data)}`);
      })
      .catch((err : BusinessError.BusinessError) => {
        log.error(`start err`, err);
      })
  }

  async selectDevice(selectDevId: number | string, sessionId: string, isCall: boolean) {
    if (this.isSelectingClickLink.get()) {
      log.error(`last select is running`);
      return;
    }
    this.isSelectingClickLink.set(true);
    setTimeout(() => {
      log.showInfo(`select device button release: ${selectDevId}`);
      this.isSelectingClickLink.set(false);
    }, Constants.DEVICE_SELECT_TRIGGER_TIME);
    log.showInfo(`lock device button: ${selectDevId}`);
    const provider = await SessionInfoProvider.getInstance();
    // const serviceStateMap = this.serviceStateMapLink.get();
    const target = CastDeviceControl.deviceManager?.getDeviceInfoById(selectDevId, isCall);
    try {
      let isBrEnable: number = access.getState();
      log.showInfo(`bluetooth for this device: ${isBrEnable} | ${target?.isLegacy} | ${target?.mediumTypes}`);
      // isBrEnable === 5---三态开 蓝牙关
      if (isBrEnable === access.BluetoothState.STATE_BLE_ON && target?.isLegacy && target?.mediumTypes === 1) {
        log.error( `bluetooth must be enabled for this device. Please enable it and try again.`);
        promptAction.showToast({
          message: $r('app.string.open_bluetooth'),
          showMode: 2
        });
        return;
      }
    } catch (err) {
      log.showError(`Failed to selectDevice: ${err}`);
    }
    // if (!isCall && (serviceStateMap['DeviceCollaboration'] === collaborationServiceManager.State.CONNECTED ||
    //   serviceStateMap['DeviceCollaboration-Dual'] === collaborationServiceManager.State.CONNECTED)) {
    //   log.error( `do not support device change under DeviceCollaboration.`);
    //   promptAction.showToast({
    //     message: $r('app.string.multi_screen_usage'),
    //     showMode: 2
    //   });
    //   return;
    // }
    if (isCall) {
      CastDeviceControl.deviceManager?.selectCallDevice(selectDevId)
        .then(() => {
          log.showInfo('panel select call device success');
        })
        .catch((err : BusinessError.BusinessError) => {
          log.error('call panel select device err:', err);
        })
    } else {
      CastDeviceControl.deviceManager?.selectDevice(selectDevId, sessionId)
        .then(() => {
          log.showInfo('panel select device success');
        })
        .catch((err : BusinessError.BusinessError) => {
          log.error('panel select device err:', err);
        })
    }
  }

  release() {
    log.showInfo('try release device manger when exit app');
    if (CastDeviceControl.deviceManager) {
      CastDeviceControl.deviceManager?.stop();
      CastDeviceControl.deviceManager?.release();
      CastDeviceControl.deviceManager = undefined;
    }
    if (this.enableDc) {
      messageChannel.offMessage(Constants.ASYNC_CAST_DEVICE_CONTROL, this.callByWorker); // 监听子线程消息
    }
    if (CastDeviceControl.controller) {
      CastDeviceControl.controller = undefined;
    }
    log.showInfo('release device manger done');
  }
}