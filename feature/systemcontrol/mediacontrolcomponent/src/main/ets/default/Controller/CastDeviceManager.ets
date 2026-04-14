/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
ompliance with the License.
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
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { sEventManager } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import { ObjectCopyUtil } from '@ohos/componenthelper/src/main/ets/utils/ObjectCopyUtil';
import audio from '@ohos.multimedia.audio';
import avSession from '@ohos.multimedia.avsession';
import BusinessError from '@ohos.base';
import promptAction from '@ohos.promptAction';
import deviceInfo from '@ohos.deviceInfo';
import Constants, {
  LocalDeviceInfo,
  DeviceSource,
  DeviceState,
  AVCastPickerDeviceIconName,
  CastingSessionInfo,
  CarInfo,
  AudioControlCode,
  DeviceType
} from '../Util/Constants';
import AVSessionManager from '@ohos.multimedia.avsession';
import SessionInfoProvider from './SessionInfoProvider';
import CommunicationUtil from '../Util/CommunicationUtil';
import { globalStorage } from '../Util/GlobalStorage';
import { DeviceSession, DfxDevice, DfxParam, MessageInfo, RadarDevice } from '../Util/CommonInterface';
import { EventType, HiSysEvent, ScenesType, BizScene, BizState, StageResult, StartCAST,
  DiscoverDeviceList, CastEnd, IsTrust, SourceController } from '../Util/HiSysEvent';
import { LocalEventCallback } from '../Util/LocalEventCallBack';
import MediaInfoProvider from './MediaInfoProvider';
import CommonUtils from '../Util/CommonUtils';
import CommonEventManager from '@ohos.commonEventManager';
import { rpc } from '@kit.IPCKit';
import { common } from '@kit.AbilityKit';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import {
  CastDeviceState,
  onDeviceStateChanged,
  offDeviceStateChanged,
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubDeviceState';

const TAG: string = 'CastDeviceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const PACKAGE_NAME = 'com.ohos.mediacontroller';
let isPlaying: boolean = false; // is playing in mode
PersistentStorage.PersistProp('lastCastingSession', '');
PersistentStorage.PersistProp('lastCastingDeviceId', '');
const systemId: number = 226;
const moduleId: number = 17;

export default class CastDeviceManager {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private sessionProvider: SessionInfoProvider | undefined;
  private mergedDeviceList: Array<LocalDeviceInfo> = [];
  private mMergedDeviceListLink: AbstractProperty<Array<LocalDeviceInfo>>;
  private mCurDeviceSelectLink: AbstractProperty<LocalDeviceInfo | undefined>;
  private curCallDeviceLink: AbstractProperty<LocalDeviceInfo | undefined>;
  private audioManager: audio.AudioManager;
  private audioRoutingManager: audio.AudioRoutingManager | undefined;
  private context: Context;
  private curDevInfo: LocalDeviceInfo;
  private curCallDevInfo: LocalDeviceInfo; // 通话设备
  private isConnectingLink: AbstractProperty<boolean> = AppStorage.setAndRef('isConnectingLink', false);
  private castingSessionLink: AbstractProperty<CastingSessionInfo | undefined> = AppStorage.setAndRef("castingSessionLink", undefined);
  private castDeviceInfoMap: Map<string, AVSessionManager.DeviceInfo> =
    new Map<string, AVSessionManager.DeviceInfo>();
  private localDeviceDescriptorMap: Map<string, audio.AudioDeviceDescriptor> =
    new Map<string, audio.AudioDeviceDescriptor>();

  private localDeviceList: Array<LocalDeviceInfo> = [];
  private callDeviceList: Array<LocalDeviceInfo> = [];
  private callDeviceListLink: AbstractProperty<Array<LocalDeviceInfo>>;
  private targetSessionId: string = '';
  private targetAvSessionController: AVSessionManager.AVSessionController | undefined;
  private isCasting: boolean = false; // is in remote device cast mode
  private isCastingLink: AbstractProperty<boolean> = AppStorage.setAndRef('isCastingLink', false);
  private isPreSelecting: boolean = false; // is cast to next remote device, keep loading state util start cast
  private isCastDeviceChanging: boolean = false; // is cast to next remote device, stop play util connected
  private lastSelectDevice: string | number = ''; // last device user select
  private isConnecting: boolean = false; // is in connecting state
  private connectingTimer: number = 0;
  private maxConnectTimeout: number = 0;
  private startControlTime: number = -1;
  private isLocalSelecting: boolean = false; // is in local selecting state
  private isNeedSort: boolean = true;
  private drmSchemes: Array<string> | undefined = undefined;
  private deviceFilter: avSession.ProtocolType | undefined = undefined;
  private appType: string | undefined = '';
  private controllerChangeCallback: LocalEventCallback | undefined = undefined;
  private sessionReleasedCallback: LocalEventCallback | undefined = undefined;
  private mediaInfoProvider: MediaInfoProvider | undefined = MediaInfoProvider.getInstance();
  private pInfoName = globalStorage.getStringByKey('packageName');
  private pInfoVersion = globalStorage.getStringByKey('packageVersion');
  private isClickLocalDevice: boolean = false; // 主动点击本机
  private isOnLine: boolean = false;
  private isSwitchNewDevice: boolean = false;
  private startSelectCastTime: number = -1;
  private isIdlConnecting: boolean = false;
  private connectId: number = 0;
  private proxy: rpc.RemoteObject | undefined = undefined;
  private static want: Want = {
    bundleName: 'com.ohos.cardistributedassist',
    abilityName: 'AudioControlServiceExtAbility'
  };
  private targetLocalId: string | number | undefined = undefined;

  constructor() {
    this.context = GlobalContext.getContext() as Context;
    this.audioManager = audio.getAudioManager();
    this.mergedDeviceList = AppStorage.get<Array<LocalDeviceInfo>>('MergedDeviceList') || [];
    this.mMergedDeviceListLink = AppStorage.setAndRef('MergedDeviceList', this.mergedDeviceList);
    this.callDeviceList = AppStorage.get<Array<LocalDeviceInfo>>('callDeviceList') || [];
    this.callDeviceListLink =  AppStorage.setAndRef('callDeviceList', this.callDeviceList);
    this.mCurDeviceSelectLink = AppStorage.setAndRef<LocalDeviceInfo | undefined>('CurDeviceSelect',
      { deviceType: audio.DeviceType.SPEAKER, deviceId: 0, deviceName: 'xxx', deviceSource: DeviceSource.LOCAL });
    this.curCallDeviceLink = AppStorage.setAndRef<LocalDeviceInfo | undefined>('curCallDevice',
      { deviceType: audio.DeviceType.SPEAKER, deviceId: 0, deviceName: 'xxx', deviceSource: DeviceSource.LOCAL });
    this.curDevInfo = {deviceId : -1, deviceType : -1};
    this.curCallDevInfo = {deviceId : -1, deviceType : -1};
    CommunicationUtil.addLocalEventListener('controllerChanged', this.getControllerChangeCallback());
    log.showInfo('init done');
  }

  release() {
    CommunicationUtil.removeLocalEventListener('controllerChanged', this.getControllerChangeCallback());
    sEventManager.off('outOutDeviceChangeEvent', this.getLocalDeviceListOnce);
    try {
      this.audioRoutingManager?.off('availableDeviceChange');
    } catch (err) {
      log.showError(`Failed to release: ${err}`);
    }
  }

  getControllerChangeCallback(): LocalEventCallback {
    if (!this.controllerChangeCallback) {
      this.controllerChangeCallback = new LocalEventCallback((sessionId : string) => {
        log.showInfo(`on controller changed, refresh session info: ${sessionId?.length < 10 ? '' :
          (sessionId?.substr(0, 5) + '**' + sessionId?.substr(sessionId?.length - 5))}`);
        this.setCastStateListener();
      });
    }
    return this.controllerChangeCallback;
  }

  getSessionReleasedCallback(): LocalEventCallback {
    if (!this.sessionReleasedCallback) {
      this.sessionReleasedCallback = new LocalEventCallback(() => {
        this.targetAvSessionController = undefined;
        this.updateMergedDeviceList();
      });
    }
    return this.sessionReleasedCallback;
  }

  public async stopCast() {
    AVSessionManager.off('deviceAvailable');
    this.castDeviceInfoMap.clear();
    this.updateMergedDeviceList();
  }

  private supportAVCast() {
    return canIUse('SystemCapability.Multimedia.AVSession.AVCast');
  }

  private async checkDeviceAndAppCapability() {
    try {
      if (!this.supportAVCast()) {
        log.error('SystemCapability.Multimedia.AVSession.AVCast not support cast source');
        return false;
      }
      if (globalStorage.getBooleanByKey('isTabletDevice')) {
        log.error('tablet device not support cast source');
        return false;
      }
      if (this.sessionProvider && this.targetAvSessionController) {
        const bundleName : string = this.sessionProvider.bundleNameMap[this.targetSessionId];
        const extras = await this.targetAvSessionController.getExtras();
        const requireAbilityList: string[] = (extras?.requireAbilityList || []) as string[];
        if (!Constants.APP_LIST_SUPPORT_CAST.includes(bundleName) && !requireAbilityList.includes('url-cast')) {
          log.error(`app not support cast source: ${bundleName}, ${JSON.stringify(extras)}`);
          return false;
        }
      } else {
        return false;
      }
      return true;
    } catch (err) {
      log.error('fail to check cast capability: ', err);
      return false;
    }
  }

  /**
   * start device discovery
   * @param sessionId AVSession Id
   * @param device change callback
   * @returns start result: false => fail
   */
  async start(sessionId: string, isFromPanel: boolean) : Promise<MessageInfo> {
    log.showInfo(`start: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    this.isNeedSort = true;
    this.targetSessionId = sessionId;
    await this.initSessionInfo(sessionId, isFromPanel);
    // stop all action first
    await this.stop();
    // start local device find
    const startLocalRes = this.startLocalDeviceDiscovery();
    // start remote device find
    let errInfo : string = '';
    if (AppStorage.get('isConnectedPadCar')) {
      this.init();
    } else {
      this.destroy();
    }
    log.showInfo(`start done: ${startLocalRes}, ${errInfo}`);
    const code : number = (!startLocalRes && errInfo) ? -1 : 0;
    return Promise.resolve<MessageInfo>({
      code: code,
      msg: errInfo,
    });
  }

  init() {

  }

  destroy() {

  }

  async initSessionInfo(sessionId: string, isFromPanel: boolean) {
    log.showInfo(`start init session info: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    this.sessionProvider = await SessionInfoProvider.getInstance();
    const sessionDesc: avSession.AVSessionDescriptor | undefined =
      this.sessionProvider?.avSessionDescriptorMap?.[this.targetSessionId];
    this.appType = sessionDesc?.type.toString();
    await this.setCastStateListener();
    if (isFromPanel) {
      log.showInfo(`session from panel do not need sessionRelease`);
      return;
    }
    CommunicationUtil.clearListener('sessionReleased');
    CommunicationUtil.addLocalEventListener('sessionReleased', this.getSessionReleasedCallback());
  }

  sessionDestroyCallback() {
    log.warn(`session destroy, notify session release: ${this.targetSessionId?.length < 10 ? '' :
      (this.targetSessionId?.substr(0, 5) + '**' + this.targetSessionId?.substr(this.targetSessionId?.length - 5))}`);
    CommunicationUtil.doLocalEventNotify('sessionReleased');
    if (this.isStartCasting) {
      this.isStartCasting = false;
      this.mediaInfoProvider?.reportRader('outputDeviceChange', BizScene.startCast,
        StartCAST.deviceConnet, StageResult.cancel, BizState.ending, {
          PEER_UDID: this.curPeerUDID, IS_TRUST: this.curIsTrust, PROTOCOL: this.curProtocol,
          APP_CALLER: this.getAppBundleName() })
    }
  }

  /**
   * add playback state listener for playing state update
   */
  async setCastStateListener() {
    log.showInfo(`start set state listener`);
    try {
      if (!this.sessionProvider) {
        log.showInfo(`start set state fail: no session provider`);
        return;
      }
      if (this.targetAvSessionController) {
        this.targetAvSessionController.off('sessionDestroy', this.sessionDestroyCallback);
      }
      this.targetAvSessionController = this.sessionProvider.avSessionControllerMap.get(this.targetSessionId);
      if (!this.targetAvSessionController) {
        log.error(`start set state fail: targetAvSessionController is null:
          ${this.targetSessionId?.length < 10 ? '' : (this.targetSessionId?.substr(0, 5) + '**' +
          this.targetSessionId?.substr(this.targetSessionId?.length - 5))}`);
        this.stopCast();
        return;
      }
      let avMetaData = await this.targetAvSessionController.getAVMetadata();
      this.deviceFilter = avMetaData?.filter;
      this.drmSchemes = avMetaData?.drmSchemes;
      log.showInfo(`get device filter: ${this.deviceFilter}`);
      AppStorage.setAndRef('deviceFilter', this.deviceFilter);
      const isSupport = await this.checkDeviceAndAppCapability();
      this.targetAvSessionController.on('sessionDestroy', this.sessionDestroyCallback);
      log.showInfo(`start set cast state done: ${isPlaying}`);
    } catch (err) {
      log.error(`start set cast state fail: ${JSON.stringify(err)}`);
      isPlaying = false;
    }
  }

  public playStateCallback = (state: AVSessionManager.AVPlaybackState) => {
    if (typeof (state.state) !== 'undefined') {
      log.showInfo(`update cast play state: ${state.state}`);
        isPlaying = state.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY;
      }
  }

  /**
   * send cast command
   */
  async sendCastCommand(command: AVSessionManager.AVCastControlCommandType, sessionId?: string) {
    log.showInfo(`try send cast command: ${command}`);
    let controller: AVSessionManager.AVCastController
    if (sessionId && sessionId !== this.targetSessionId) {
      log.showInfo(`try get target castcontroller: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
        sessionId?.substr(sessionId?.length - 5))}`);
      controller = await AVSessionManager.getAVCastController(sessionId);
    }
  }

  /**
   * deviceId anonymize
   */
  private anonymize(deviceId: number | string | undefined) {
    if (!deviceId) {
      return 'unknown';
    }
    let radarDeviceId: string = deviceId.toString();
    if (radarDeviceId.includes('uuid')) {
      radarDeviceId = radarDeviceId.substring(5);
    }
    return radarDeviceId.length < 10 ? '' : radarDeviceId.substr(0, 5) + '**' +
    radarDeviceId.substr(radarDeviceId.length - 5);
  }

  /**
   * 选择通话设备
   * @param deviceId
   * @returns
   */
  selectCallDevice(deviceId: number | string): Promise<void> {
    const target = this.getDeviceInfoById(deviceId, true);
    if (!target) {
      return Promise.reject('select device err: deviceId invalid');
    }
    if (this.isConnecting) {
      return Promise.reject(`select device err: connecting`);
    }
    this.setConnectingState(deviceId);
    this.updateDeviceState(deviceId, DeviceState.CONNECTING, true);
    return this.selectLocalDeviceAsync(target, true)
      .then(() => {
        this.curCallDevInfo = ObjectCopyUtil.deepClone(target);
        this.clearConnectingState(deviceId);
      })
      .catch((err : BusinessError.BusinessError) => {
        log.showInfo(`selectLocalDeviceAsync radar err: ${err}`);
        this.clearConnectingState(deviceId);
        this.updateDeviceState(deviceId, DeviceState.IDLE, true);
        return Promise.reject(err.message);
      });
  }

  /**
   * change output device
   */
  async selectDevice(deviceId: number | string, sessionId: string) : Promise<void> {
    const target = this.getDeviceInfoById(deviceId, false);
    this.targetLocalId = target?.deviceSource === DeviceSource.LOCAL ? deviceId : undefined;
    log.showInfo(`select device start: ${deviceId?.toString().length < 10 ? '' :
      (deviceId?.toString().substr(0, 5) + '**' + deviceId?.toString().substr(deviceId?.toString().length - 5))},
      connect:${this.isConnecting}`);
    if (!target) {
      return Promise.reject('select device err: deviceId invalid');
    }
    if (this.isConnecting) {
      return Promise.reject(`select device err: is in connecting\pre-select state: ${this.lastSelectDevice}`);
    }
    this.lastSelectDevice = deviceId;
    this.isNeedSort = false;
    if (deviceId === this.curDevInfo.deviceId) {
      this.updateMergedDeviceList();
      return Promise.reject('select device err: already selected');
    }
    this.setConnectingState(deviceId);
    this.updateDeviceState(deviceId, DeviceState.CONNECTING, true);
    let preDeviceType = this.curDevInfo.deviceType;
    let preDeviceName = this.curDevInfo.deviceName ? this.curDevInfo.deviceName : '';
    let preProtocol = 'LOCAL';
    let protocol = 'LOCAL';
    let serviceName = this.getServiceName(target);
    this.startControlTime = new Date().getTime();
    let packageName: string = PACKAGE_NAME;
    if (!this.sessionProvider) {
      log.error(`get package name fail without provider`);
    } else {
      packageName = this.sessionProvider.bundleNameMap[sessionId];
      log.showInfo(`check point get package name :${packageName}`);
    }
    if (target.deviceSource === DeviceSource.LOCAL) {
      // this.publishCommonEvent(Constants.PUBLISH_EVENT_CAST_DISCONNECT_DEVICE);
      log.showInfo(`selectDevice radar start`);
      this.mediaInfoProvider?.reportRader('selectDevice', BizScene.castEnd,
        CastEnd.sourceCastStart, StageResult.cancel, BizState.start, { LOCAL_UDID: this.anonymize(deviceId),
          APP_CALLER: this.getAppBundleName() });
      return this.selectLocalDeviceAsync(target, false)
        .then(() => {
          // 结束断开投播-选择本机
          this.isClickLocalDevice = true;
          log.showInfo(`selectDevice radar end`);
          this.mediaInfoProvider?.reportRader('selectLocalDeviceAsync', BizScene.castEnd,
            CastEnd.sourceCastEnd, StageResult.cancel, BizState.ending, { LOCAL_UDID: this.anonymize(deviceId),
              APP_CALLER: this.getAppBundleName(), SERVICE_DURATION: (new Date().getTime() -
              this.startSelectCastTime) / 1000 });
          this.isCasting = false;
          this.isCastingLink.set(this.isCasting);
          if (this.enableDc) {
            messageChannel.sendMessage('syncAppStorage', {name: 'isCasting', value: this.isCasting});
          }
          this.reportSwitchDevice(preDeviceType, target.deviceType, target.deviceName, packageName, protocol,
            // preDeviceName, preProtocol, target.networkId, serviceName, 'SUCCESS');
            preDeviceName, preProtocol, 'SUCCESS');
          this.curDevInfo = ObjectCopyUtil.deepClone(target);
          this.clearConnectingState(deviceId);
          // 移除投播session
          let curCastSession = this.castingSessionLink.get();
          if (curCastSession?.sessionId === sessionId) {
            this.castingSessionLink.set(undefined);
            if (this.enableDc) {
              messageChannel.sendMessage('syncAppStorage', {name: 'castingSessionInfo', value: undefined});
            }
          }
        })
        .catch((err : BusinessError.BusinessError) => {
          // 结束断开投播-选择本机
          log.showInfo(`selectLocalDeviceAsync radar err: ${err}`);
          this.mediaInfoProvider?.reportRader('selectLocalDeviceAsync', BizScene.castEnd,
            CastEnd.sourceCastEnd, StageResult.cancel, BizState.ending,
            { LOCAL_UDID: this.anonymize(deviceId), ERROR_CODE: err.code,
              APP_CALLER: this.getAppBundleName() });
          this.reportSwitchDeviceFail(deviceId, 'CONNECT_ERROR', packageName);
          this.reportSwitchDevice(preDeviceType, target.deviceType, target.deviceName, packageName, protocol,
            preDeviceName, preProtocol, 'CONNECT_ERROR');
          this.clearConnectingState(deviceId);
          this.updateDeviceState(deviceId, DeviceState.IDLE, true);
          return Promise.reject(err.message);
        });
    }
  }
  public sendMsgToPad(msg: number){
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    if (this.proxy) {
      data.writeInterfaceToken(this.proxy.getDescriptor());
      data.writeInt(msg);
      log.showInfo(`sendMsgToHiCar ${msg}`);
      this.proxy?.sendMessageRequest(msg, data, reply, option)
        .then((result: rpc.RequestResult) => {
          log.showInfo( `send Message Request: ${JSON.stringify(result)}`);
          if (result.errCode === 0) {
            log.showInfo(`send Msg request success`);
          } else {
            log.showInfo(`send Msg request error ${result.errCode} `);
          }
        })
        .catch((e: BusinessError.BusinessError) => {
          log.showInfo(`sendMessageRequest failed, message: ${e}`);
        })
        .finally(() => {
          data.reclaim();
          reply.reclaim();
          this.isLocalSelecting = false;
          this.updateMergedDeviceList();
        });
    }
  }

  private async selectLocalDeviceAsync(target: LocalDeviceInfo, isCall: boolean) : Promise<void> {
    if (!this.audioRoutingManager) {
      return Promise.reject('select device err: audioRoutingManager not ready');
    }
    if (!!AppStorage.get('isConnectedPadCar') && target.deviceType === 2) {
      return this.sendMsgToPad(AudioControlCode.SET_AUDIO_ON_PAD);
    } else if (!!AppStorage.get('isConnectedPadCar') && target.deviceType ===
    (AppStorage.get('carInfo') as CarInfo).deviceType) {
      return this.sendMsgToPad(AudioControlCode.SET_AUDIO_ON_CAR);
    } else {
      const selectDevDescriptor: audio.AudioDeviceDescriptor = this.localDeviceDescriptorMap[target.deviceId];
      if (!selectDevDescriptor) {
        return Promise.reject('select device err: target descriptor not found');
      }
      const selectDevDescriptorArray: audio.AudioDeviceDescriptors = [];
      selectDevDescriptorArray.push(selectDevDescriptor);
      log.showInfo(`select local device: check len: ${selectDevDescriptorArray.length}`);
      if (isCall) {
        // 选择通话设备
        return this.audioRoutingManager.selectOutputDeviceByFilter(
          {
            rendererInfo: {
              usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION,
              rendererFlags: 0,
            }
          },
          selectDevDescriptorArray,
        );
      } else if (!target.fromCall) {
        // 选择媒体设备，与通话设备不一致
        return this.audioRoutingManager.selectOutputDevice(selectDevDescriptorArray)
          .then(() => {
            AppStorage.Set('lastCastingSession', '');
            AppStorage.Set('lastCastingDeviceId', '');
          })
          .catch((err: BusinessError.BusinessError) => {
            log.error(`select device err: ${err.message}`);
            return Promise.reject(err.message);
          })
          .finally(() => {
            log.showInfo('select device finish');
            this.isLocalSelecting = false;
          });
      } else {
        // 选择媒体设备，与通话设备一致
        this.isLocalSelecting = false;
      }
    }
  }

  private getAppBundleName(): string {
    let packageName: string = PACKAGE_NAME;
    if (!this.sessionProvider || !this.targetSessionId) {
      log.showInfo(`get package name fail without provider`);
    } else {
      packageName = this.sessionProvider.bundleNameMap[this.targetSessionId];
      log.showInfo(`check point get package name :${packageName}`);
    }
    return packageName;
  }

  reportSwitchDeviceFail(deviceId : string | number, reason : string, packageName?: string) : void {
    let dfxParam : DfxParam = {REASON : reason, PNAMEID: this.pInfoName, PVERSIONID: this.pInfoVersion,
      APP_TYPE: this.appType };
    this.mergedDeviceList.forEach((device: LocalDeviceInfo) => {
      if (device.deviceId === deviceId) {
        dfxParam.DEVICE_NAME = device.deviceName;
        dfxParam.DEVICE_TYPE = device.deviceType;
      }
    });
    if (!packageName) {
      if (!this.sessionProvider) {
        log.error(`get package name fail without provider, set default packageName`);
        dfxParam.PACKAGE_NAME = PACKAGE_NAME;
      } else {
        packageName = this.sessionProvider.bundleNameMap[this.targetSessionId];
        log.showInfo(`check targetSessionId: ${this.targetSessionId?.length < 10 ? '' :
          (this.targetSessionId?.substr(0, 5) + '**' +
          this.targetSessionId?.substr(this.targetSessionId?.length - 5))} get package name:${packageName}`);
      }
    } else {
      dfxParam.PACKAGE_NAME = packageName;
    }
    log.showInfo(`set reportSwitchDeviceFail packageName:${dfxParam.PACKAGE_NAME},deviceName:${dfxParam.DEVICE_NAME}`);
    this.sessionProvider?.reportScenesHiEvent(EventType.SWITCH_DEVICE_FAILED, dfxParam, true);
  }

  reportSwitchDevice(preDeviceType : number, deviceType : number, deviceName: string | undefined, packageName: string |
  undefined, protocol: string, preDeviceName: string, preProtocol: string, reason: string): void {
    let packageNameForDfx: string = '';
    if (!packageName) {
      if (!this.sessionProvider) {
        log.error(`reportSwitchDevice get package name fail without provider, set default packageName`);
        packageNameForDfx = PACKAGE_NAME;
      } else {
        packageNameForDfx = this.sessionProvider.bundleNameMap[this.targetSessionId];
        log.showInfo(`check reportSwitchDevice targetSessionId: ${this.targetSessionId?.length < 10 ? '' :
          (this.targetSessionId?.substr(0, 5) + '**' +
          this.targetSessionId?.substr(this.targetSessionId?.length - 5))} packageName:${packageName}`);
      }
    } else {
      packageNameForDfx = packageName;
    }
    let version: string = this.sessionProvider?.appVersionMap.get(packageNameForDfx) || 'default';
    log.showInfo(`check reportSwitchDevice packageName: ${packageNameForDfx}`);
    if (this.startControlTime > 0) {
      const dfxParam : DfxParam = {
        PNAMEID: this.pInfoName,
        PVERSIONID: this.pInfoVersion,
        APP_TYPE: this.appType,
        PACKAGE_NAME: packageNameForDfx,
        TIME_COST: new Date().getTime() - this.startControlTime,
        PREV_DEVICE_TYPE : preDeviceType,
        PREV_DEVICE_NAME: preDeviceName,
        DEVICE_NAME: deviceName,
        DEVICE_TYPE: deviceType,
        PROTOCOL : protocol ? protocol : 'LOCAL',
        PREV_PROTOCOL: preProtocol,
        CONTROLINTERFACE: globalStorage.getNumberByKey('isShowSwitch'),
        TIME: this.startControlTime,
        SCREENSTATUS: this.mediaInfoProvider?.getScreenStatus(),
        DEVICEMODELTYPE: this.mediaInfoProvider?.getDeviceModelType(),
        SCREENFOLDEDSTATUS: this.mediaInfoProvider?.getFold(),
        CONTROL_RESULT: reason,
        PACKAGE_VERSION: version
      };
      this.sessionProvider?.reportScenesHiEvent(EventType.SWITCH_DEVICE, dfxParam, true);
      this.startControlTime = -1;
    }
  }

  private setConnectingState(deviceId: string | number) {
    log.showInfo(`set Connecting State: ${deviceId?.toString().length < 10 ? '' :
      (deviceId?.toString().substr(0, 5) + '**' + deviceId?.toString().substr(deviceId?.toString().length - 5))}`);
    this.isConnecting = true;
    this.connectingTimer = setTimeout(() => {
      log.showInfo(`Connecting State release: ${deviceId?.toString().length < 10 ? '' :
        (deviceId?.toString().substr(0, 5) + '**' + deviceId?.toString().substr(deviceId?.toString().length - 5))}`);
      this.isConnecting = false;
      clearTimeout(this.connectingTimer);
    }, Constants.DEVICE_CONNECT_TIMEOUT);
  }

  private clearConnectingState(deviceId: string | number) {
    log.showInfo(`clear Connecting State: ${deviceId?.toString().length < 10 ? '' :
      (deviceId?.toString().substr(0, 5) + '**' + deviceId?.toString().substr(deviceId?.toString().length - 5))}`);
    this.isConnecting = false;
    clearTimeout(this.connectingTimer);
  }

  private setConnectTimeout(sessionId: string, deviceId: string) {
    log.showInfo(`set Connecting timeout: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}, ${deviceId?.toString().length < 10 ? '' :
      (deviceId?.toString().substr(0, 5) + '**' + deviceId?.toString().substr(deviceId?.toString().length - 5))}`);
    if (this.maxConnectTimeout) {
      log.showInfo(`clear last Connecting timeout: ` + this.maxConnectTimeout);
      clearTimeout(this.maxConnectTimeout);
      this.maxConnectTimeout = 0;
    }
    this.maxConnectTimeout = setTimeout(async () => {
      log.error(`connect timeout: ${deviceId?.toString().length < 10 ? '' : (deviceId?.toString().substr(0, 5) + '**' +
        deviceId?.toString().substr(deviceId?.toString().length - 5))}, stop casting`);
      // 投播超时
      this.isStartCasting = false;
      let radarErrorCode: number = (((systemId) << 21) | ((moduleId) << 16) | (0xFFFF));
      log.error(`connect timeout radarErrorCode: ${radarErrorCode}`);
      this.mediaInfoProvider?.reportRader('setConnectTimeout', BizScene.startCast, StartCAST.deviceConnet,
        StageResult.fail, BizState.ending, { ERROR_CODE: radarErrorCode, LOCAL_UDID: this.anonymize(deviceId),
          APP_CALLER: this.getAppBundleName() },
        );
      try {
        promptAction.showToast({
          message: $r('app.string.device_error'),
          showMode: 2
        });
      } catch (err) {
        log.showError(`Faild to show toast about cast fail. Code: ${err.code}, message: ${err.message}`);
      }
      let preDeviceType = this.curDevInfo.deviceType;
      let preDeviceName = this.curDevInfo.deviceName ? this.curDevInfo.deviceName : '';
      let preProtocol = 'LOCAL';
      const target: AVSessionManager.DeviceInfo = this.castDeviceInfoMap[deviceId];
      let protocol = 'LOCAL';
      let packageName: string = this.sessionProvider?.bundleNameMap[sessionId];
      let serviceName = this.getServiceName(target);
      this.reportSwitchDevice(preDeviceType, target.deviceType, target.deviceName, packageName, protocol,
        preDeviceName, preProtocol, 'CONNECT_TIME_OUT');
      this.reportSwitchDeviceFail(deviceId, 'CONNECT_TIME_OUT');
      await AVSessionManager.stopCasting({
        sessionId: sessionId,
      })
        .then(data => {
          log.showInfo(`stop cast success: ${JSON.stringify(data)}`);
        })
        .catch((err : BusinessError.BusinessError) => {
          log.error(`select device err: ${JSON.stringify(err)}`);
        });
      log.showInfo('stop done timerId = ' + this.maxConnectTimeout);
      this.updateDeviceState(deviceId, DeviceState.IDLE);
    }, Constants.MAX_CONNECT_TIMEOUT);
  }

  private clearConnectTimeout() {
    log.showInfo(`clear Connecting timeout: ${this.maxConnectTimeout}`);
    clearTimeout(this.maxConnectTimeout);
    this.maxConnectTimeout = 0;
  }

  /**
   * stop device discovery
   */
  async stop() {
    log.showInfo('stop');
    try {
      if (this.audioRoutingManager) {
        this.audioRoutingManager.off('availableDeviceChange');
      }
      if (this.targetAvSessionController) {
        this.targetAvSessionController.off('outputDeviceChange', this.doOutputDeviceChange);
      }
      sEventManager.off('outOutDeviceChangeEvent', this.getLocalDeviceListOnce);
      offDeviceStateChanged('deviceStateChanged', this.deviceStateChanged);
      this.clearConnectTimeout();
      AVSessionManager.off('deviceAvailable');
      try {
        AVSessionManager.off('deviceOffline');
      } catch (err) {
        log.showError('off deviceOffline listener fail: ' + JSON.stringify(err));
      }
      log.showInfo('stop to set list clean');
      let curCastSession = this.castingSessionLink.get();
      if (curCastSession?.sessionId && this.targetSessionId !== curCastSession?.sessionId &&
        this.deviceFilter !== undefined && this.deviceFilter !== AVSessionManager.ProtocolType.TYPE_LOCAL) {
        log.showInfo(`From one cast switch to another cast And an app play in local.`)
      } else {
        this.mergedDeviceList = [];
        this.castDeviceInfoMap?.clear();
        this.localDeviceDescriptorMap?.clear();
        this.mMergedDeviceListLink?.set(this.mergedDeviceList);
      }
      if (this.enableDc) {
        messageChannel.sendMessage('syncDeviceListData', { deviceList: this.mergedDeviceList });
      }
    } catch (err) {
      log.showError(`stop with list clean failed: ${err?.code}-${err?.message}`);
    }
    log.showInfo('stop done with list clean');
  }

  public static on(event: 'deviceChanged' | 'outputDeviceChanged' | 'callDeviceChanged' | 'callStateChange',
    callback: LocalEventCallback) {
    log.showInfo('add deviceChanged listen');
    CommunicationUtil.addLocalEventListener(event, callback);
  }

  public static off(event: 'deviceChanged' | 'outputDeviceChanged' | 'callDeviceChanged' | 'callStateChange',
    callback: LocalEventCallback) {
    log.showInfo('remove deviceChanged listen');
    CommunicationUtil.removeLocalEventListener(event, callback);
  }

  private notifyDeviceChanged(force?: boolean) {
    log.showInfo(`notify device changed: ${this.mergedDeviceList?.length}`);
    if (!force) {
      log.warn('do not update device state in preselecting state');
      return;
    }
    // update link info
    this.callDeviceListLink?.set(this.callDeviceList);
    this.mMergedDeviceListLink?.set(this.mergedDeviceList);
    if (this.enableDc) {
      messageChannel.sendMessage('syncDeviceListData', {
        deviceList: this.mergedDeviceList,
        callDeviceList: this.callDeviceList,
      });
    }
    this.mergedDeviceList.forEach((device: LocalDeviceInfo) => {
      if (device?.deviceState === DeviceState.WORKING) {
        this.mCurDeviceSelectLink?.set(device);
        if (this.enableDc) {
          messageChannel.sendMessage('syncAppStorage', { name: 'CurDeviceSelect', value: device });
        }
      }
    });
    this.callDeviceList.forEach((device: LocalDeviceInfo) => {
      if (device?.deviceState === DeviceState.WORKING) {
        this.curCallDeviceLink?.set(device);
        if (this.enableDc) {
          messageChannel.sendMessage('syncAppStorage', { name: 'curCallDevice', value: device });
        }
      }
    });
    CommunicationUtil.doLocalEventNotify('deviceChanged', this.mergedDeviceList);
    CommunicationUtil.doLocalEventNotify('callDeviceChanged', this.mergedDeviceList);
  }

  public getLocalDeviceListOnce = async () => {
    log.showInfo('getLocalDeviceListOnce start');
    if (!this.audioRoutingManager) {
      log.showInfo('startLocalDeviceDiscovery audioRoutingManager is null');
      return;
    }
    let localDevices: audio.AudioDeviceDescriptors =
      this.audioRoutingManager.getAvailableDevices(audio.DeviceUsage.MEDIA_OUTPUT_DEVICES);
    log.showInfo(`get all output device list raw: ${localDevices.length}`);
    localDevices.reverse();
    const tempDeviceList: LocalDeviceInfo[] = [];
    const deviceDescriptorMapTemp: Map<string, audio.AudioDeviceDescriptor> =
      new Map<string, audio.AudioDeviceDescriptor>();
    for (let i = localDevices.length - 1; i >= 0; i--) {
      if ((localDevices[i].networkId === 'LocalDevice' &&
        localDevices[i].deviceType === audio.DeviceType.REMOTE_CAST) ||
        (localDevices[i].networkId !== 'LocalDevice' &&
        !CommonUtils.isSupportDistributeScene(localDevices[i].networkId))) {
        continue;
      }
      const dev: audio.AudioDeviceDescriptor = localDevices[i];
      const tempDeviceInfo: LocalDeviceInfo = {
        deviceId: dev.id,
        deviceType: dev.deviceType.valueOf(),
        deviceName: await this.getNameByDescriptor(dev),
        deviceIcon: this.getIconByType(dev.deviceType, dev.address, dev.networkId),
        deviceSource: DeviceSource.LOCAL,
        deviceState: DeviceState.IDLE,
        deviceAddress: dev.address,
        networkId: dev.networkId,
      };
      tempDeviceList.push(tempDeviceInfo);
      deviceDescriptorMapTemp[dev.id] = dev;
    }
    this.localDeviceList = tempDeviceList;
    // pad car
    if (AppStorage.get('isConnectedPadCar')) {
      let carInfoTemp = AppStorage.get('carInfo') as CarInfo;
      log.showInfo( `start CarDevice Discovery: ${JSON.stringify(carInfoTemp)}`);
      const padCarTempDeviceList: LocalDeviceInfo[] = [];
      const padCarTempDeviceInfo: LocalDeviceInfo = {
        deviceId: carInfoTemp.deviceId,
        deviceType: carInfoTemp.deviceType,
        deviceName: carInfoTemp.deviceName,
        deviceAddress: carInfoTemp.brMac,
        deviceIcon: $r(AVCastPickerDeviceIconName.CAR_SYMBOL),
        deviceSource: DeviceSource.LOCAL,
        deviceState: DeviceState.IDLE,
      };
      padCarTempDeviceList.push(padCarTempDeviceInfo);
      this.localDeviceList = this.localDeviceList.filter(item => {
        if (item.deviceType == audio.DeviceType.BLUETOOTH_SCO ||
          item.deviceType == audio.DeviceType.BLUETOOTH_A2DP) {
          return item.deviceAddress !== padCarTempDeviceInfo.deviceAddress;
        } else {
          return true;
        }
      });
      this.localDeviceList = [...this.localDeviceList, ...padCarTempDeviceList];
    }
    // 有通话
    let callDevices: audio.AudioDeviceDescriptors =
      this.audioRoutingManager.getAvailableDevices(audio.DeviceUsage.CALL_OUTPUT_DEVICES);
    log.showInfo(`get call device list raw: ${callDevices.length}`);
    callDevices.reverse();
    const tempCallDeviceList: LocalDeviceInfo[] = [];
    for (let i = callDevices.length - 1; i >= 0; i--) {
      if ((callDevices[i].networkId === 'LocalDevice' &&
        callDevices[i].deviceType === audio.DeviceType.REMOTE_CAST) ||
        (callDevices[i].networkId !== 'LocalDevice' &&
        !CommonUtils.isSupportDistributeScene(callDevices[i].networkId))) {
        // 过滤无线投屏
        continue;
      }
      const dev: audio.AudioDeviceDescriptor = callDevices[i];
      const tempDeviceInfo: LocalDeviceInfo = {
        deviceId: dev.id,
        deviceType: dev.deviceType.valueOf(),
        deviceName: await this.getNameByDescriptor(dev, true),
        deviceIcon: this.getIconByType(dev.deviceType, dev.address, dev.networkId, true),
        deviceSource: DeviceSource.LOCAL,
        deviceState: DeviceState.IDLE,
        deviceAddress: dev.address,
        networkId: dev.networkId,
        fromCall: true,
      };
      tempCallDeviceList.push(tempDeviceInfo);
      deviceDescriptorMapTemp[dev.id] = dev;
    }
    this.callDeviceList = tempCallDeviceList;
    this.localDeviceDescriptorMap = deviceDescriptorMapTemp;
    // 合并设备列表
    this.updateMergedDeviceList();
  };
  private isStartCasting: boolean = false;
  private curProtocol: string = '';
  private curPeerUDID: string | undefined = undefined;
  private curIsTrust: IsTrust = IsTrust.unknown;
  private lastConnectState: AVSessionManager.ConnectionState = AVSessionManager.ConnectionState.STATE_DISCONNECTED;

  /**
   * init routing manager and listen device change event
   */
  private startLocalDeviceDiscovery(): boolean {
    log.showInfo('try get local device list');
    this.audioRoutingManager = this.audioManager.getRoutingManager();
    if (!this.audioRoutingManager) {
      log.error('setRoutingManagerListener fail without audioRoutingManager');
      return false;
    }
    // get device list now
    this.getLocalDeviceListOnce();
    // add device change listener
    this.getDeviceChangeListener();
    return true;
  }

  private getDeviceChangeListener() {
    if (!this.audioRoutingManager) {
      log.error('getDeviceChangeListener fail without audioRoutingManager');
      return;
    }
    try {
      this.audioRoutingManager.on('availableDeviceChange', audio.DeviceUsage.CALL_OUTPUT_DEVICES,
        async (deviceChangeAction) => {
          log.showInfo(`Device change callback, type=${deviceChangeAction.type}`);
          let hasCall: boolean | undefined = AppStorage.get('hasCall');
          if (hasCall) {
            this.getLocalDeviceListOnce();
          }
        });
    } catch (err) {
      log.error(TAG, `Fail to get call availableDeviceChange: ${err}`);
    }
    try {
      this.audioRoutingManager.on('availableDeviceChange', audio.DeviceUsage.MEDIA_OUTPUT_DEVICES,
        async (deviceChangeAction) => {
        log.showInfo(`Device change callback, type=${deviceChangeAction.type}`);
        deviceChangeAction.deviceDescriptors?.forEach((changeDev: audio.AudioDeviceDescriptor) => {
          log.showInfo('change dev info : ' + changeDev.id + '|' + changeDev.deviceType);
        })
        this.getLocalDeviceListOnce();
      });
    } catch (err) {
      log.error(TAG, `Fail to get availableDeviceChange: ${err}`);
    }
    sEventManager.subscribe('outOutDeviceChangeEvent', this.getLocalDeviceListOnce);
  }

  getServiceName(target: LocalDeviceInfo | AVSessionManager.DeviceInfo): string | undefined {
    return 'NONE';
  }

  /**
   * 设备状态变更
   */
  private deviceStateChanged = (data: CastDeviceState) => {
    const radarErrorCode = Math.abs(data.radarErrorCode);
    if (data.deviceState === DeviceType.DISCONNECTED && radarErrorCode !== 0) {
      this.mediaInfoProvider?.reportRader('doOutputDeviceChange', BizScene.startCast,
        StartCAST.deviceConnet, StageResult.fail, BizState.ending, {
          PEER_UDID: this.curPeerUDID, IS_TRUST: this.curIsTrust, PROTOCOL: this.curProtocol,
          ERROR_CODE: radarErrorCode, APP_CALLER: this.getAppBundleName() })
    }

    let showDmModal: boolean = !!AppStorage.get('showDmModal');
    log.showInfo(`deviceStateChanged ${data.deviceState}, reasonCode ${data.reasonCode},
      radarErrorCode, ${data.radarErrorCode}, show ${showDmModal}`);
    if (data.deviceState !== Constants.DEVICE_AUTH_CODE) {
      return;
    }
  }

  private doOutputDeviceChange = async (connectState: AVSessionManager.ConnectionState | number,
                                         device: AVSessionManager.OutputDeviceInfo): Promise<void> => {
    log.showInfo(`output device changed: ${connectState}, ${this.isPreSelecting}`);
    if (device?.devices?.[0]?.deviceName === 'RemoteCast') {
      return;
    }
    // 授权非可信设备
    if (connectState === Constants.DEVICE_AUTH_CODE) {
      return;
    }
    const isLocal = device?.devices?.[0]?.castCategory === AVSessionManager.AVCastCategory.CATEGORY_LOCAL;
    if (connectState === AVSessionManager.ConnectionState.STATE_CONNECTED && isLocal && !this.isPreSelecting) {
      log.showInfo('set cur dev to local now');
      const curDev = device?.devices?.[0];
      this.curDevInfo = {
        deviceId: curDev?.deviceId,
        deviceType: curDev?.deviceType,
        deviceSource: DeviceSource.LOCAL,
        deviceState: DeviceState.WORKING
      };
    }
    if (connectState === AVSessionManager.ConnectionState.STATE_CONNECTED && !isLocal) {
      this.isCasting = true;
      this.isCastingLink.set(this.isCasting);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', {name: 'isCasting', value: this.isCasting});
      }
      this.clearConnectingState(device?.devices?.[0]?.deviceId);
      this.isSwitchNewDevice = false;
      this.clearConnectTimeout();
      if (this.isCastDeviceChanging) {
        log.showInfo(`is remote change mode, restore play state`);
        this.isCastDeviceChanging = false;
        setTimeout(() => {
          log.showInfo(`try send play command`);
          this.sendCastCommand('play');
        }, 600);
      }
      let deviceInfo : DeviceSession = {
        sessionId: this.targetSessionId,
        device : device,
        connectState : connectState,
      };
      let preProtocol = 'LOCAL';
      let protocol = 'LOCAL';
      let serviceName = this.getServiceName(device?.devices?.[0]);
      this.reportSwitchDevice(this.curDevInfo.deviceType, device?.devices?.[0]?.deviceType,
        device?.devices?.[0]?.deviceName, undefined, protocol, this.curDevInfo.deviceName || '', preProtocol, 'SUCCESS');
      CommunicationUtil.doLocalEventNotify('outputDeviceChanged', deviceInfo);
      if (this.enableDc) {
        messageChannel.sendMessage('syncLocalNotify', { name: 'outputDeviceChanged', value: deviceInfo });
      }
      this.updateMergedDeviceList();
    }
    if (connectState === AVSessionManager.ConnectionState.STATE_DISCONNECTED) {
      const deviceId = device?.devices?.[0]?.deviceId;
      log.showInfo(`device disconnect: ${deviceId?.toString().length < 10 ? '' : (deviceId?.toString().substr(0, 5) +
        '**' + deviceId?.toString().substr(deviceId?.toString().length - 5))}`);
      let deviceSession : DeviceSession = {
        sessionId : this.targetSessionId,
        device : device,
        connectState : connectState
      };
      CommunicationUtil.doLocalEventNotify('outputDeviceChanged', deviceSession);
      if (this.enableDc) {
        messageChannel.sendMessage('syncLocalNotify', { name: 'outputDeviceChanged', value: deviceSession });
      }
      this.deviceDisconnectProcess(deviceId);
      await this.sessionProvider?.doSessionCollection();
    }
  }

  // 设备断开
  private deviceDisconnectProcess(deviceId: string | number, needRemove?: boolean) {
    log.showInfo(`device disconnect proc: ${this.isCasting}, ${this.isPreSelecting}, ${this.isClickLocalDevice}, ${this.curDevInfo.deviceSource}`);
    if (!this.isPreSelecting) {
      this.isCastDeviceChanging = false;
      if (!this.isCasting && !this.isClickLocalDevice) {
        // try to connect a new device fail
        this.reportErrorEvent(-1, 'CONTROL_FAILED');
      } else if (this.curDevInfo.deviceSource === DeviceSource.CAST &&
        !this.isClickLocalDevice && !this.isSwitchNewDevice) {
        this.reportErrorEvent(-2, 'REMOTE_DISCONNECTED');
      }
      this.isCasting = false;
      this.isCastingLink.set(this.isCasting);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', {name: 'isCasting', value: this.isCasting});
      }
      this.clearConnectingState(deviceId);
      if (!this.isSwitchNewDevice) {
        this.clearConnectTimeout();
      }
    }
    this.updateMergedDeviceList();
  }

  private reportErrorEvent(errorId: number, reason: string): void {
    HiSysEvent.getEventParam(EventType.MEDIA_ROUTER_UNEXPECTED_BEHAVIOR)
      .updateScenes(ScenesType.SCENES_MEDIA_CONTROL)
      .updateExtendParam('ERROR_CODE', errorId)
      .updateExtendParam('REASON', reason)
      .updateExtendParam('APP_TYPE', this.appType || 'audio')
      .reportEvent(false);
  }

  deviceAvailableCallback(device: AVSessionManager.OutputDeviceInfo, startTime : number) {
    log.showInfo(`device available: ${this.isPreSelecting}`);
    const devices = device?.devices;
    if (!devices || !devices.length) {
      log.error('cast+ device is empty');
      return;
    }
    let dfxDeviceList : DfxDevice[] = []
    let isNeedUpdate : boolean = false
    for (let i = 0; i < devices.length; i++) {
      const dev: AVSessionManager.DeviceInfo = devices[i];
      log.showInfo(`device available: ${dev.authenticationStatus},
        ${dev.deviceType}, ${dev.deviceName}`);
      if (!dev) {
        continue;
      }
      const tempDeviceInfo: LocalDeviceInfo = {
        deviceId: dev.deviceId,
        deviceType: dev.deviceType.valueOf(),
        deviceName: dev.deviceName,
        deviceIcon: this.getCastDeviceIconByType(dev.deviceType),
        deviceSource: DeviceSource.CAST,
        deviceState: DeviceState.IDLE,
        supportedProtocols: dev.supportedProtocols,
        authenticationStatus:dev.authenticationStatus, //接收后端返回是否可信字段
        isLegacy: dev.isLegacy,
        mediumTypes: dev.mediumTypes,
        networkId: dev.networkId
      };

      const dexDevice : DfxDevice = {DEVICE_TYPE : dev.deviceType.valueOf(), DEVICE_NAME : dev.deviceName};
      dfxDeviceList.push(dexDevice);

      if (this.maxConnectTimeout && tempDeviceInfo.deviceId === this.lastSelectDevice) {
        log.showInfo(' upadte connecting deviceState.');
        isNeedUpdate = true;
        tempDeviceInfo.deviceState = DeviceState.CONNECTING;
      }

      this.castDeviceInfoMap[dev.deviceId] = dev;
    }
    let radarDeviceListAll: RadarDevice[] = [];
    if (this.isPreSelecting) {
      log.warn('is preselecting, do not update merge list');
      return;
    }
    log.showInfo(`MEDIA_ROUTER_DEVICE_FOUND size = ${dfxDeviceList.length}`);
    if (this.isOnLine) {
      this.isOnLine = false;
      let dfxParam : DfxParam = {
        TIME_COST : new Date().getTime() - startTime,
        LIST: JSON.stringify(dfxDeviceList),
        PNAMEID: this.pInfoName,
        PVERSIONID: this.pInfoVersion,
        DEVICEMODELTYPE: this.mediaInfoProvider?.getDeviceModelType()};
      HiSysEvent.getEventParam(EventType.MEDIA_ROUTER_DEVICE_FOUND).updateAllExtendParam(dfxParam).reportEvent(true);
    }
    // 展开设备列表 雷达打点
    this.mediaInfoProvider?.reportRader('deviceAvailableCallback', BizScene.discoverDevice,
      DiscoverDeviceList.expendSearchDevice, StageResult.sussess, BizState.ending,
      { DISCOVERY_DEVICE_LIST: JSON.stringify(radarDeviceListAll) });
    this.updateMergedDeviceList(isNeedUpdate);
  }

  private deviceOfflineCallback(deviceId: string) {
    log.showInfo(`on device offline: ${deviceId?.toString().length < 10 ? '' : (deviceId?.toString().substr(0, 5) +
      '**' + deviceId?.toString().substr(deviceId?.toString().length - 5))}`);
    if (!deviceId) {
      log.error('offline device is empty');
      return;
    }

    if (deviceId === this.lastSelectDevice) {
      log.warn('select device connecting but meet offline, clear connectingState when upToLine nextTime');
      this.isSwitchNewDevice = false;
      this.clearConnectTimeout();
    }
    log.showInfo(`on device offline done, refresh merge list now: ${this.curDevInfo.deviceId === deviceId}`);
    if (this.curDevInfo.deviceId === deviceId) {
      this.deviceDisconnectProcess(deviceId, true);
    } else {
      this.updateMergedDeviceList();
    }
  }

  private updateDeviceState(targetId : string | number, state: DeviceState, isForce?: boolean) : void {
    log.showInfo(`updateDeviceState targetId = ${targetId}`);
    if (!targetId) {
      return;
    }
    log.warn('updateDeviceState: ' + targetId + ', ' + state);
    let needRefresh = false;
    this.callDeviceList.forEach((device: LocalDeviceInfo) => {
      if (device.deviceId === targetId) {
        device.deviceState = state;
        needRefresh = true;
      }
    });
    let firstDevice: LocalDeviceInfo | undefined = this.callDeviceList.find((device: LocalDeviceInfo) => {
      return device.deviceState === DeviceState.WORKING
    });
    if (firstDevice) {
      if (this.mergedDeviceList[0]?.fromCall) {
        this.mergedDeviceList[0] = ObjectCopyUtil.deepClone(firstDevice);
      } else {
        this.mergedDeviceList.unshift(ObjectCopyUtil.deepClone(firstDevice));
      }
    }
    this.mergedDeviceList.forEach((device: LocalDeviceInfo) => {
      if (device.deviceId === targetId) {
        device.deviceState = state;
        needRefresh = true;
      }
    });
    if (needRefresh) {
      this.notifyDeviceChanged(isForce);
    }
  }

  /**
   * merge local devices and cast+ devices
   */
  private async updateMergedDeviceList(isNeedUpdateState: boolean = false) {
    log.showInfo(`start merge device:isLocalSelecting=${this.isLocalSelecting}`);
    if (this.isLocalSelecting) {
      log.showInfo(`merge device cancel: is selecting local device`);
      return;
    }
    let tempDeviceList: LocalDeviceInfo[] = [];
    const deviceInfoMap: Map<number | string, LocalDeviceInfo> = new Map<string, LocalDeviceInfo>();
    // update current output device info
    await this.getCurShowingDevice();
    // merge local devices
    let forceSelectId: number | string = '';
    this.localDeviceList?.forEach((device: LocalDeviceInfo) => {
      if (!deviceInfoMap[device.deviceId]) {
        let isWorking = false;
        let isBlueToothDevice = device.deviceType == audio.DeviceType.BLUETOOTH_SCO ||
          device.deviceType == audio.DeviceType.BLUETOOTH_A2DP;
        if (this.curDevInfo.deviceAddress === device.deviceAddress && (isBlueToothDevice ||
          (this.curDevInfo.deviceAddress && !!AppStorage.get('isConnectedPadCar')))) {
          this.targetLocalId = undefined;
          isWorking = true;
        } else if ((device.deviceId === this.curDevInfo?.deviceId && (!this.targetLocalId ||
          this.targetLocalId === device.deviceId))) {
          this.targetLocalId = undefined;
          isWorking = true;
        }
        device.deviceState = isWorking ? DeviceState.WORKING : DeviceState.IDLE;
        device.isLocal = [audio.DeviceType.EARPIECE, audio.DeviceType.SPEAKER].includes(device.deviceType);
        device.authenticationStatus = 1;
        tempDeviceList.push(device);
        deviceInfoMap[device.deviceId] = device;
      }
      log.showInfo(`merge device ing: ${this.curDevInfo.deviceType}, ${device.deviceType}`);
    });
    // 通话设备
    let hasCall: boolean | undefined = AppStorage.get('hasCall');
    let addonLocalDevice: LocalDeviceInfo | undefined = undefined; // 媒体设备列表添加一条本地设备
    if (hasCall) {
      this.callDeviceList.forEach((device: LocalDeviceInfo) => {
        device.deviceState = device.deviceId === this.curCallDevInfo.deviceId ?
          DeviceState.WORKING : DeviceState.IDLE;
        device.isLocal = [audio.DeviceType.EARPIECE, audio.DeviceType.SPEAKER].includes(device.deviceType);
        device.authenticationStatus = 1;
        if (device.deviceState === DeviceState.WORKING) {
          addonLocalDevice = ObjectCopyUtil.deepClone(device);
          addonLocalDevice.deviceState = addonLocalDevice.deviceState;
        }
        log.showInfo(`merge call device type: ${this.curCallDevInfo.deviceType}, ${device.deviceType}`);
      });
      this.callDeviceList = this.getSortDevice(this.callDeviceList);
      tempDeviceList = [];
    }

    this.mergedDeviceList = tempDeviceList;
    // sort it
    this.mergedDeviceList = this.sortDeviceList(tempDeviceList);
    if (addonLocalDevice) {
      this.mergedDeviceList.unshift(addonLocalDevice);
    }
    let selectDevice = this.mergedDeviceList.filter(item => {
      return item.deviceState === DeviceState.WORKING;
    });
    if (selectDevice.length === 0) {
      this.mergedDeviceList.forEach((item : LocalDeviceInfo, index : number) => {
        log.showInfo(`update merged index ${index}, ${item.deviceState}, ${item.isLocal}, ${item.isLegacy}`);
        if (this.targetLocalId && this.targetLocalId === item.deviceId) {
          log.showInfo('set current working device to local target');
          item.deviceState = DeviceState.WORKING;
        } else if (!this.targetLocalId && item.deviceId === 1) {
          log.showInfo('set current working device to speaker, maybe not correct');
          item.deviceState = DeviceState.WORKING;
        }
      });
    }
    globalStorage.setGlobalObjectByKey('mergedDeviceListTemp', this.mergedDeviceList);
    this.notifyDeviceChanged();
  }

  private getSortDevice(deviceList: LocalDeviceInfo[]): LocalDeviceInfo[] {
    log.showInfo('sort device list');
    let speakerDevice: LocalDeviceInfo | undefined = undefined;
    let earpieceDevice: LocalDeviceInfo | undefined = undefined;
    let workingDevice: LocalDeviceInfo | undefined = undefined;
    let trustedList: LocalDeviceInfo[] = [];
    let unTrustedList: LocalDeviceInfo[] = [];
    deviceList.forEach((device: LocalDeviceInfo, index: number) => {
      log.showInfo(`deviceList index ,${index}, ${device?.deviceName}`);
      if (device.deviceType === audio.DeviceType.SPEAKER && device.isLocal &&
        device.networkId === 'LocalDevice') {
        speakerDevice = device; // 本机扬声器
      } else if (device.deviceType === audio.DeviceType.EARPIECE) {
        earpieceDevice = device; // 本机听筒
      } else if (device.deviceState === DeviceState.WORKING) {
        workingDevice = device; // 正在出声的设备
      } else if (device.authenticationStatus === 1) {
        trustedList.push(device); // 可信设备
      } else {
        unTrustedList.push(device); // 非可信设备


      }
    })
    let result: LocalDeviceInfo[] = [...trustedList, ...unTrustedList];
    if (workingDevice) {
      result.unshift(workingDevice); // 正在出声的设备
    }
    if (earpieceDevice) {
      result.unshift(earpieceDevice); // 本机听筒
    }
    if (speakerDevice) {
      result.unshift(speakerDevice); // 本机扬声器
    }
    return result;
  }

  private sortDeviceList(deviceList: Array<LocalDeviceInfo>) {
    log.showInfo(`sort device list: ${this.isNeedSort}`);
    let mergedDeviceListTemp = globalStorage.getGlobalObjectByKey('mergedDeviceListTemp') as LocalDeviceInfo[];
    if (!this.isNeedSort) {
      if (mergedDeviceListTemp.length >= deviceList.length) { // 设备下线
        mergedDeviceListTemp.forEach((dev, index) => {
          // 设备相同但是有相关状态变了
          let sameButNotState: LocalDeviceInfo | undefined = deviceList.find(item => item.deviceId === dev.deviceId);
          sameButNotState ? mergedDeviceListTemp[index] = sameButNotState : null;
        })
        let showMergedDevice: LocalDeviceInfo[] =
          mergedDeviceListTemp.filter(item => deviceList.includes(item)) as LocalDeviceInfo[];
        log.showInfo( `mergedDeviceListTemp.length >= deviceList.length: ${showMergedDevice.length}`);
        return showMergedDevice;
      } else { // 设备上线
        let deviceListTemp = this.getSortDevice(deviceList);
        log.showInfo( `mergedDeviceListTemp.length < deviceList.length: ${deviceListTemp.length}`);
        return deviceListTemp;
      }
    }
    let deviceListTemp = this.getSortDevice(deviceList);
    log.showInfo( `isNeedSort is ture: ${deviceListTemp.length}`);
    return deviceListTemp;
  }

  /**
   * get current output devices
   */
  private async getCurShowingDevice() {
    let tempDevInfo: LocalDeviceInfo = {deviceId: -1, deviceType: -1};
    let tempCallDevInfo: LocalDeviceInfo = {deviceId: -1, deviceType: -1};
    // get current device from audio routing manager
    if (this.audioRoutingManager) {
      log.showInfo('get curDev from audioRoutingManager');
      try {
        const rendererInfo: audio.AudioRendererInfo = {
          usage: audio.StreamUsage.STREAM_USAGE_MUSIC, rendererFlags: 0,
        };
        const curDevicesAvailable : audio.AudioDeviceDescriptors =
          await this.audioRoutingManager.getPreferOutputDeviceForRendererInfo(rendererInfo);
        log.showInfo(`get curDev from audioRoutingManager res: ${curDevicesAvailable[0]?.deviceRole}`);
        for (let i = 0; i < curDevicesAvailable.length; i++) {
          let curDev : audio.AudioDeviceDescriptor = curDevicesAvailable[i];
          log.showInfo(`get curDev from audioRoutingManager, type: ${curDev.deviceType}, id: ${curDev.id}, networkId: ${curDev.networkId}`);
          // 车机发声
          if (!!AppStorage.get('isConnectedPadCar') && curDev.networkId !== 'LocalDevice') {
            let carInfoTemp = AppStorage.get('carInfo') as CarInfo;
            tempDevInfo = {
              deviceId: carInfoTemp.deviceId,
              deviceType: carInfoTemp.deviceType,
              deviceName: carInfoTemp.deviceName,
              deviceIcon: $r(AVCastPickerDeviceIconName.CAR_SYMBOL),
              deviceSource: DeviceSource.LOCAL,
              deviceState: DeviceState.WORKING,
              deviceAddress: carInfoTemp.brMac,
              networkId: curDev.networkId
            }
          } else {
            tempDevInfo = {
              deviceId: curDev.id,
              deviceType: curDev.deviceType.valueOf(),
              deviceName: await this.getNameByDescriptor(curDev),
              deviceIcon: this.getIconByType(curDev.deviceType, curDev.address, curDev.networkId),
              deviceSource: DeviceSource.LOCAL,
              deviceState: DeviceState.WORKING,
              networkId: curDev.networkId,
              deviceAddress: curDev.address
            };
          }
        }
      } catch (err) {
        log.error(`get curDev from audioRoutingManager, err: ${err}`);
      }
      if (this.lastSelectDevice === tempDevInfo.deviceId) {
        AppStorage.setOrCreate('isSelectingClick', false);
      }
      let hasCall: boolean | undefined = AppStorage.get('hasCall');
      if (hasCall) {
        try {
          const rendererCallInfo: audio.AudioRendererInfo = {
            usage: audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION, rendererFlags: 0,
          };
          const curCallDevicesAvailable : audio.AudioDeviceDescriptors =
            await this.audioRoutingManager.getPreferOutputDeviceForRendererInfo(rendererCallInfo);
          for (let i = 0; i < curCallDevicesAvailable.length; i++) {
            let curDev : audio.AudioDeviceDescriptor = curCallDevicesAvailable[i];
            tempCallDevInfo = {
              deviceId: curDev.id,
              deviceType: curDev.deviceType.valueOf(),
              deviceName: await this.getNameByDescriptor(curDev, true),
              deviceIcon: this.getIconByType(curDev.deviceType, curDev.address, curDev.networkId, true),
              deviceSource: DeviceSource.LOCAL,
              deviceState: DeviceState.WORKING,
              networkId: curDev.networkId,
              deviceAddress: curDev.address,
              fromCall: true,
            };
          }
        } catch (err) {
          log.error(`get curCallDev from audioRoutingManager, err: ${err}`);
        }
      }
    }
    if (this.supportAVCast() && this.targetAvSessionController) {
      log.showInfo('get curDev from cast');
      await this.targetAvSessionController.getOutputDevice()
        .then((device: AVSessionManager.OutputDeviceInfo) => {
          log.showInfo(`get curDev from avsession`);
          device?.devices?.forEach(dev => {
            if (dev.castCategory === AVSessionManager.AVCastCategory.CATEGORY_LOCAL ||
              dev.deviceName === 'RemoteCast') {
              this.isCasting = false;
              this.isCastingLink.set(this.isCasting);
              if (this.enableDc) {
                messageChannel.sendMessage('syncAppStorage', {name: 'isCasting', value: this.isCasting});
              }
              log.showInfo(`getCurShowingDevice isCasting: ${this.isCasting}`);
              return; // ignore local device from av session
            }
            tempDevInfo = {
              deviceId: dev.deviceId,
              deviceType: dev.deviceType.valueOf(),
              deviceName: dev.deviceName,
              deviceIcon: this.getCastDeviceIconByType(dev.deviceType),
              deviceSource: DeviceSource.CAST,
              deviceState: DeviceState.WORKING,
              supportedProtocols: dev.supportedProtocols,
              authenticationStatus: dev.authenticationStatus,
              isLegacy: dev.isLegacy,
              mediumTypes: dev.mediumTypes,
              networkId: dev.networkId,
            };
            this.castDeviceInfoMap[dev.deviceId] = dev;
            this.isCasting = true;
            this.isCastingLink.set(this.isCasting);
            if (this.enableDc) {
              messageChannel.sendMessage('syncAppStorage', {name: 'isCasting', value: this.isCasting});
            }
          });
        })
        .catch((err : BusinessError.BusinessError) => {
          log.error(`get curDev from cast+, err: ${JSON.stringify(err)}`);
        })
    }
    if (tempDevInfo.deviceSource === DeviceSource.LOCAL) {
      AppStorage.Set('lastCastingSession', '');
      AppStorage.Set('lastCastingDeviceId', '');
    }
    this.curDevInfo = ObjectCopyUtil.deepClone(tempDevInfo);
    this.curCallDevInfo = ObjectCopyUtil.deepClone(tempCallDevInfo);
  }

  getDeviceInfoById(deviceId: number | string, isCall: boolean): LocalDeviceInfo | undefined {
    let result : LocalDeviceInfo | undefined = undefined;
    if (isCall) {
      this.callDeviceList.some((device: LocalDeviceInfo) => {
        if (device.deviceId === deviceId) {
          result = device;
          return true;
        }
        return false;
      });
    } else {
      this.mergedDeviceList?.some((device: LocalDeviceInfo) => {
        if (device.deviceId === deviceId) {
          result = device;
          return true; // return for function:some, just like break in for-loop
        }
        return false;
      });
    }
    return result;
  }

  private getNearlinkDefaultName(address: string = ''): string {
    try {
      const maskAddr = address?.slice(-3);
      const rs: Resource = $r('app.string.sound_output_device_nearlink');
      return this.context.resourceManager.getStringSync(rs, maskAddr);
    } catch (err) {
      log.showError(`getNearlinkDefaultName failed. error code: ${err?.code}, message: ${err?.message}`);
      return '';
    }
  }

  private async getNameByDescriptor(deviceDescriptor: audio.AudioDeviceDescriptor,
    isCall: boolean = false) : Promise<string> {
    let tempDeviceName: Resource = $r('app.string.LocalDevice');
    let tempDeviceNameStr: string | undefined;
    switch (deviceDescriptor.deviceType) {
      case audio.DeviceType.INVALID:
      case audio.DeviceType.USB_HEADSET:
      case audio.DeviceType.DEFAULT:
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
      case audio.DeviceType.MIC:
        tempDeviceName = $r('app.string.WiredDevice');
        break;
      case audio.DeviceType.EARPIECE:
        tempDeviceName = $r('app.string.LocalDevice');
        if (deviceDescriptor.displayName) {
          tempDeviceNameStr = await this.context.resourceManager.getStringValue(tempDeviceName.id);
          tempDeviceNameStr += (' (' + deviceDescriptor.displayName + ')');
        }
        if (isCall) {
          let tempCallDeviceName = $r('app.string.CallEarpiece');
          tempDeviceNameStr = await this.context.resourceManager.getStringValue(tempCallDeviceName.id);
        }
        break;
      case audio.DeviceType.SPEAKER:
        tempDeviceName = $r('app.string.LocalDevice');
        let deviceName = await CommonUtils.getLocalDeviceName();
        tempDeviceNameStr = await this.context.resourceManager.getStringValue(tempDeviceName.id);
        tempDeviceNameStr += (' (' + deviceName + ')');
        if (isCall) {
          let tempCallDeviceName = $r('app.string.CallSpeaker');
          tempDeviceNameStr = await this.context.resourceManager.getStringValue(tempCallDeviceName.id);
        }
        if (CommonUtils.isSupportDistributeScene(deviceDescriptor.networkId)) {
          tempDeviceNameStr = deviceDescriptor.displayName;
        }
        break;
      case audio.DeviceType.BLUETOOTH_SCO:
      case audio.DeviceType.BLUETOOTH_A2DP:
        tempDeviceName = $r('app.string.BluetoothDevice');
        if (deviceDescriptor.name) {
          tempDeviceNameStr = deviceDescriptor.name;
        }
        break;
      case (23 as audio.DeviceType):
        tempDeviceName = $r('app.string.WiredCastDevice');
        break;
      case audio.DeviceType.NEARLINK:
        tempDeviceName = $r('app.string.sound_output_device_nearlink');
        tempDeviceNameStr = deviceDescriptor.name || this.getNearlinkDefaultName(deviceDescriptor.address);
        break;
      case Constants.DEVICE_TYPE_HEARING_AID:
        tempDeviceName = $r('app.string.HearingAid');
        if (deviceDescriptor.name) {
          tempDeviceNameStr = deviceDescriptor.name;
        }
        break;
      default:
        tempDeviceName = $r('app.string.WiredDevice');
        break;
    }
    if (!tempDeviceNameStr) {
      tempDeviceNameStr = await this.context.resourceManager.getStringValue(tempDeviceName.id);
    }
    return tempDeviceNameStr || '';
  }

  public getCastDeviceIconByType(deviceType: AVSessionManager.DeviceType | number): Resource {
    log.showInfo(`try get cast icon: ${deviceType}`);
    let tempDeviceIcon: Resource;
    if (!this.supportAVCast()) {
      return $r(AVCastPickerDeviceIconName.WIRED_SYMBOL);
    }
    switch (deviceType) {
      case AVSessionManager.DeviceType.DEVICE_TYPE_SMART_SPEAKER:
        tempDeviceIcon = $r(AVCastPickerDeviceIconName.SOUND_BOX_SYMBOL);
        break;
      case AVSessionManager.DeviceType.DEVICE_TYPE_BLUETOOTH:
        tempDeviceIcon = $r(AVCastPickerDeviceIconName.BLUETOOTH_SYMBOL);
        break;
      case 6: // 6 for pad device type
        tempDeviceIcon = $r(AVCastPickerDeviceIconName.PAD_SYMBOL);
        break;
      case 8: // 8 for pc device type
        tempDeviceIcon = $r(AVCastPickerDeviceIconName.MATEBOOK_SYMBOL);
        break;
      default:
        tempDeviceIcon = $r(AVCastPickerDeviceIconName.MATEBOOK_SYMBOL);
        break;
    }
    return tempDeviceIcon;
  }

  private getIconByType(deviceType : audio.DeviceType, deviceAddress?: string,
    networkId?: string, isCall?: boolean) : Resource {
    let tempDeviceIcon: Resource;
    switch (deviceType) {
      case audio.DeviceType.INVALID:
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
      case audio.DeviceType.MIC:
      case audio.DeviceType.USB_HEADSET:
      case audio.DeviceType.DEFAULT:
        tempDeviceIcon = $r(AVCastPickerDeviceIconName.WIRED_SYMBOL);
        break;
      case audio.DeviceType.EARPIECE:
        tempDeviceIcon = $r(AVCastPickerDeviceIconName.EARPIECE_SYMBOL);
        break;
      case audio.DeviceType.SPEAKER:
        if (deviceInfo.deviceType === '2in1') {
          tempDeviceIcon = $r(AVCastPickerDeviceIconName.MATEBOOK_SYMBOL);
        } else if (deviceInfo.deviceType === 'tablet') {
          tempDeviceIcon = $r(AVCastPickerDeviceIconName.PAD_SYMBOL)
        } else if (isCall && networkId === 'LocalDevice') {
          tempDeviceIcon = $r(AVCastPickerDeviceIconName.SPEAKER_CALL_SYMBOL);
        } else if (CommonUtils.isSupportDistributeScene(networkId)) {
          tempDeviceIcon = $r(AVCastPickerDeviceIconName.CAR_SYMBOL);
        } else {
          tempDeviceIcon = $r(AVCastPickerDeviceIconName.PHONE_SYMBOL);
        }
        break;
      case audio.DeviceType.BLUETOOTH_SCO:
      case audio.DeviceType.BLUETOOTH_A2DP:
        tempDeviceIcon = $r(`${CommonUtils.getBluetoothFillIcon(deviceAddress)}`);
        break;
      case audio.DeviceType.NEARLINK:
        tempDeviceIcon = $r(`${CommonUtils.getNearlinkFillIcon(deviceAddress)}`);
        break;
      case Constants.DEVICE_TYPE_HEARING_AID:
        tempDeviceIcon = $r(AVCastPickerDeviceIconName.HEARING_AID_SYMBOL);
        break;
      default:
        tempDeviceIcon = $r(AVCastPickerDeviceIconName.WIRED_SYMBOL);
        break;
    }
    return tempDeviceIcon;
  }
}