/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import AVSessionManager from '@ohos.multimedia.avsession';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/utils/CheckEmptyUtils';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { AccountMgr } from '@ohos/frameworkwrapper/src/main/ets/accountmanager/AccountManager';
import { IconResourceManager } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconResourceManager';
import image from '@ohos.multimedia.image';
import { observer, call } from '@kit.TelephonyKit';
import CommunicationUtil from '../Util/CommunicationUtil';
import Constants, { ShowingBundleTS, CastingSessionInfo, DeviceType, CallSessionInfo,
  BundleCategoryInfo } from '../Util/Constants';
import CastDeviceManager from './CastDeviceManager';
import { globalStorage } from '../Util/GlobalStorage';
import { DeviceSession, DfxParam, RadarParam } from '../Util/CommonInterface';
import { EventType, HiSysEvent, ScenesType } from '../Util/HiSysEvent';
import bundleManager from '@ohos.bundle.bundleManager';
import type ctx from '@ohos.app.ability.common';
import osAccount from '@ohos.account.osAccount';
import { LocalEventCallback } from '../Util/LocalEventCallBack';
import { resourceManager } from '@kit.LocalizationKit';
import { AVSessionAdapter } from '../model/AVSessionAdapter';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import {
  CastDeviceState,
  onDeviceStateChanged,
  offDeviceStateChanged,
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubDeviceState';
// import { appInfoManager } from '@kit.AppGalleryKit';
import audio from '@ohos.multimedia.audio';

const TAG = 'SessionInfoProvider_systemUi';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export default class SessionInfoProvider {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  // 是否已退出
  public static isQuiting: boolean = false;
  // 应用的控制avSessionController集合
  public avSessionControllerMap: Map<string, AVSessionManager.AVSessionController> =
    new Map<string, AVSessionManager.AVSessionController>();
  // 应用的描述集合
  public avSessionDescriptorMap: Map<string, AVSessionManager.AVSessionDescriptor> =
    new Map<string, AVSessionManager.AVSessionDescriptor>();
  // 应用的bundleName集合
  public bundleNameMap: Map<string, string> = new Map<string, string>();
  // 应用的version集合
  public appVersionMap: Map<string, string> = new Map<string, string>();
  // 应用的abilityName集合
  public abilityNameMap: Map<string, string> = new Map<string, string>();
  // 应用的sessionType集合
  public sessionTypeMap: Map<string, boolean> = new Map<string, boolean>();
  // 应用的sessionTypeAudio集合
  public sessionTypeAudioMap: Map<string, boolean> = new Map<string, boolean>();
  // 图标缓存，避免重复创建
  public logoPixelMap: Map<string, image.PixelMap> = new Map<string, image.PixelMap>();
  // 应用名称，避免重复创建
  public appNameMap: Map<string, string> = new Map<string, string>();
  // session列表缓存
  public sessionListLink: AbstractProperty<Array<string>> = AppStorage.setAndRef('sessionList', []);
  // 当前session列表
  public sessionListCache: string[] = [];
  // 当前topSessionId
  public topSessionId: string = '';
  // 暂停后的视频session
  private stopVideoSessionList: string[] = [];
  public isActive: boolean = false;
  public hasCallLink: AbstractProperty<boolean> = AppStorage.setAndRef('hasCall', false);
  private phoneSession: CallSessionInfo | undefined = undefined; // 蜂窝通话
  private voipSession: CallSessionInfo | undefined = undefined; // VOIP
  private isOsAccountUnlocked: boolean = false;
  private bundleCategoryMap: Map<string, BundleCategoryInfo> = new Map<string, BundleCategoryInfo>();
  private callSessionLink: AbstractProperty<CallSessionInfo | undefined> =
    AppStorage.setAndRef('callSessionInfo', undefined);
  private callSessionListCache: string[] = [];
  // sessionInfoProvider实例
  private static provider: SessionInfoProvider | null = null;
  private userId: number | undefined = undefined;
  private appModuleMap: Map<string, string> = new Map();
  public targetSessionId: string = 'default';
  private castingSessionLink: AbstractProperty<CastingSessionInfo | undefined> =
    AppStorage.setAndRef('castingSessionInfo', undefined);
  private outputDeviceCallback: LocalEventCallback | undefined = undefined;
  private serviceDieCallback: LocalEventCallback | undefined = undefined;
  // session是否是pcm投播集合
  public sessionPcmCastMap: Map<string, boolean> = new Map<string, boolean>();
  public deviceState: number = DeviceType.DISCONNECTED;
  private hasOnDeviceStateChanged: boolean = false;
  private audioManager: audio.AudioManager = audio.getAudioManager();

  static async getInstance() : Promise<SessionInfoProvider> {
    SessionInfoProvider.isQuiting = false;
    if (!SessionInfoProvider.provider) {
      log.showInfo('session getInstance new')
      SessionInfoProvider.provider = new SessionInfoProvider();
      await SessionInfoProvider.provider.init();
      AVSessionAdapter.getInstance();
    }
    log.showInfo('session getInstance done')
    return SessionInfoProvider.provider;
  }

  async init() {
    log.showInfo('SessionInfoProvider init')
    this.registerSessionListener();
    await this.doSessionCollection();
    CommunicationUtil.doLocalEventNotify('sessionListChanged');
    globalStorage.setNumberByKey('isShowSwitch', -1);
    if (this.enableDc) {
      messageChannel.sendMessage('syncGlobalStorage', { name: 'isShowSwitch', value: -1 });
    }
  }

  /**
   * 注册监听
   * @param event
   * @param callback
   */
  public static on(event: 'sessionChanged' | 'controllerChanged' | 'sessionListChanged' | 'callSessionChanged' |
                   'topSessionChangeHis' | 'deviceNotification' | 'sessionDestroy' | 'sessionServiceDie',
                   callback: LocalEventCallback | undefined) {
    CommunicationUtil.addLocalEventListener(event, callback);
  }

  /**
   * 取消监听
   * @param event
   */
  public static off(event: 'sessionChanged' | 'controllerChanged' | 'topSessionChangeHis' | 'deviceNotification' | 'sessionDestroy',
                    callback: LocalEventCallback | undefined) {
    CommunicationUtil.removeLocalEventListener(event, callback);
  }

  public checkIsTopSession(sessionId: string) {
    return this.sessionListCache.length > 0 && sessionId === this.topSessionId;
  }

  /**
   * 判断当前sessionId是否为投播cast
   * @param sessionId
   * @returns
   */

  public checkIsPcmCast(sessionId: string): boolean {
    return !!this.sessionPcmCastMap.get(sessionId);
  }

  // 是否有callSession
  public checkHasCall() {
    return this.callSessionListCache.length > 0;
  }

  /**
   * sessionId是否为callSession
   * @param sessionId
   * @returns
   */
  public checkIsCallSession(sessionId: string) {
    log.showInfo(`check IsCallSession: ${this.callSessionListCache?.includes(sessionId)}`);
    return this.callSessionListCache?.includes(sessionId);
  }

  /**
   * Cast投播时，通过bundleName查找session
   * @param targetBundleName
   * @returns
   */
  public findSessionWithBundleName(targetBundleName: string): AVSessionManager.AVSessionDescriptor | null {
    log.showInfo(`check targetBundleName : ${targetBundleName}`);
    if (!this.avSessionDescriptorMap) {
      return null;
    }
    for (let i = 0; i < this.sessionListCache.length; i++) {
      let item : AVSessionManager.AVSessionDescriptor = this.avSessionDescriptorMap[this.sessionListCache[i]];
      if (item?.elementName.bundleName === targetBundleName) {
        log.showInfo(`match sessionListCache: ${item?.sessionId?.length < 10 ? '' :
          (item?.sessionId?.substr(0, 5) + '**' + item?.sessionId?.substr(item?.sessionId?.length - 5))},
          ${item?.elementName.bundleName}`)
        return item;
      }
    }
    for (let i = 0; i < this.callSessionListCache.length; i++) {
      let item : AVSessionManager.AVSessionDescriptor = this.avSessionDescriptorMap[this.callSessionListCache[i]];
      if (item?.elementName.bundleName === targetBundleName) {
        log.showInfo(`match callSessionListCache: ${item?.sessionId?.length < 10 ? '' :
          (item?.sessionId?.substr(0, 5) + '**' + item?.sessionId?.substr(item?.sessionId?.length - 5))},
          ${item?.elementName.bundleName}`)
        return item;
      }
    }
    for (let i = 0; i < this.stopVideoSessionList.length; i++) {
      let item : AVSessionManager.AVSessionDescriptor = this.avSessionDescriptorMap[this.stopVideoSessionList[i]];
      if (item?.elementName.bundleName === targetBundleName) {
        log.showInfo(`match stopVideoSessionList: ${item?.elementName.bundleName},
          ${item?.sessionId?.length < 10 ? '' : (item?.sessionId?.substr(0, 5) + '**' +
          item?.sessionId?.substr(item?.sessionId?.length - 5))}`)
        return item;
      }
    }
    return null;
  }

  /**
   * 刷新session列表，持久化缓存SessionListLink
   * @param sessionList
   */
  public refreshSessionList(sessionList: Array<string>) {
    log.showInfo('refreshSessionList in')
    let newSessionList: string[] = [];
    for (let i = 0; i < sessionList.length; i++) {
      newSessionList.push(sessionList[i]);
    }
    log.showInfo(`set canColdStart to ${newSessionList.length > 0}`);
    AppStorage.setOrCreate('canColdStart', newSessionList.length > 0);
    if (this.enableDc) {
      messageChannel.sendMessage('syncAppStorage', {name: 'canColdStart',
        value: newSessionList.length > 0});
    }
    if (newSessionList.length <= 0) {
      newSessionList.push('default');
      this.bundleNameMap['default'] = '';
      this.abilityNameMap['default'] = '';
    }
    this.sessionListCache = newSessionList;
    this.topSessionId = newSessionList[0] || '';
    if (!this.sessionListLink) {
      return;
    }
    this.sessionListLink.set(newSessionList);
    if (this.enableDc) {
      messageChannel.sendMessage('syncSessionList', { sessionList: newSessionList })
    }
    if (newSessionList[0] !== this.targetSessionId) {
      this.targetSessionId = newSessionList[0];
      log.showInfo(`refreshSessionList with new target: ${this.targetSessionId?.length < 10 ? '' :
        (this.targetSessionId?.substr(0, 5) + '**' +
        this.targetSessionId?.substr(this.targetSessionId?.length - 5))}`);
    }
    if (this.avSessionControllerMap.get(this.targetSessionId)) {
      let avSessionController = this.avSessionControllerMap.get(this.targetSessionId);
      let outputDevice = avSessionController?.getOutputDeviceSync();
      this.refreshCurRemoteDeviceSelectLink(this.targetSessionId,
        AVSessionManager.ConnectionState.STATE_CONNECTED, outputDevice);
    } else {
      this.refreshCurRemoteDeviceSelectLink(this.targetSessionId,
        AVSessionManager.ConnectionState.STATE_DISCONNECTED);
    }
  }

  /**
   * 为sessionId创建controller
   * @param sessionId
   * @returns
   */
  public async createNewController(sessionId: string): Promise<AVSessionManager.AVSessionController | undefined> {
    // 如果sessionId已存在controller，则直接返回
    if (this.avSessionControllerMap.get(sessionId)) {
      return this.avSessionControllerMap.get(sessionId);
    }
    // 为sessionId创建controller
    const sessionController: AVSessionManager.AVSessionController = await AVSessionManager.createController(sessionId);
    log.showInfo(`create controller res: old=${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);

    if (sessionController.sessionId) {
      // 创建成功， 设置output监听
      this.doOutputDeviceListener(sessionController);
      this.avSessionControllerMap.set(sessionController.sessionId, sessionController);
    }
    return sessionController;
  }

  private doOutputDeviceListener(sessionController: AVSessionManager.AVSessionController): void {
    sessionController?.on('outputDeviceChange',
      async (connectState: AVSessionManager.ConnectionState, device: AVSessionManager.OutputDeviceInfo) =>
    this.refreshCurRemoteDeviceSelectLink(sessionController?.sessionId, connectState, device));
    let getAvSessionDescriptor: AVSessionManager.AVSessionDescriptor =
      this.avSessionDescriptorMap[sessionController?.sessionId];
    if (getAvSessionDescriptor.isTopSession) {
      let outputDevice: AVSessionManager.OutputDeviceInfo = sessionController.getOutputDeviceSync();
      if (outputDevice?.devices?.[0]?.castCategory !== AVSessionManager.AVCastCategory.CATEGORY_LOCAL &&
        outputDevice?.devices?.[0]?.deviceName !== 'RemoteCast') {
        log.showInfo(`doOutputDeviceListenner refresh for remote alive`);
        AppStorage.setOrCreate('CurRemoteDevSelect', outputDevice?.devices?.[0]?.deviceType);
        if (this.enableDc) {
          messageChannel.sendMessage('syncAppStorage', {name: 'CurRemoteDevSelect',
            value: outputDevice?.devices?.[0]?.deviceType});
        }
      } else {
        log.showInfo(`doOutputDeviceListenner refresh for remote not exist`);
        AppStorage.setOrCreate('CurRemoteDevSelect', -1);
        if (this.enableDc) {
          messageChannel.sendMessage('syncAppStorage', {name: 'CurRemoteDevSelect', value: -1});
        }
      }
    }
  }


  /**
   * 刷新session数据
   */
  public async doSessionCollection() {
    log.showInfo(`doSessionCollection`);
    let sessionList: string[] = [];
    let callSession: string = '';
    let callSessionListCache: string[] = [];
    let descriptors: AVSessionManager.AVSessionDescriptor[] = [];
    let audioScene: audio.AudioScene = audio.AudioScene.AUDIO_SCENE_DEFAULT;
    try {
      audioScene = this.audioManager.getAudioSceneSync();
      log.showInfo(`doSessionCollection audioScene is ${audioScene}`);
    } catch (err) {
      log.error(`doSessionCollection audioScene err ${err?.code}, ${err?.message}`);
    }
    if (audioScene === audio.AudioScene.AUDIO_SCENE_DEFAULT && this.phoneSession !== undefined) {
      this.phoneSession = undefined; // 清空蜂窝通话显示
    }
    try {
      descriptors = await AVSessionManager.getAllSessionDescriptors();
    } catch (err) {
      log.error(`doSessionCollection getAllSessionDescriptors err ${JSON.stringify(err)}`);
    }
    if (!descriptors) {
      log.showInfo('getAllSessionDescriptors fail, show default');
      this.refreshSessionList(sessionList);
      let hasCallValue: boolean = !!this.phoneSession && !ControlCenterPluginMgr.isPcMode;
      log.showInfo(`no descriptors, setCall ${hasCallValue}, hasPhone ${!!this.phoneSession}`);
      this.setCallSession(hasCallValue, this.phoneSession);
      return;
    }
    let topSessionIndex: number = descriptors.findIndex((session: AVSessionManager.AVSessionDescriptor) => {
      return session?.isTopSession;
    });
    // castSession is topSession
    let castSessionIndex: number = descriptors.findIndex((session: AVSessionManager.AVSessionDescriptor) => {
      return session?.sessionTag === 'RemoteCast';
    });
    if (castSessionIndex >= 0) {
      topSessionIndex = castSessionIndex;
    }
    log.showInfo(`descriptor list length : ${descriptors.length}, target index : ${topSessionIndex}`);
    if (topSessionIndex >= 0) {
      let topSession: AVSessionManager.AVSessionDescriptor[] = descriptors.slice(topSessionIndex, topSessionIndex + 1);
      descriptors.splice(topSessionIndex, 1);
      let otherSession: AVSessionManager.AVSessionDescriptor[] = descriptors;
      descriptors = [...topSession, ...otherSession];
    }
    // 投播session
    const castDeviceIndex = descriptors.findIndex((item: AVSessionManager.AVSessionDescriptor) => {
      return item.outputDevice.devices.find((device: AVSessionManager.DeviceInfo) => {
        return device.castCategory === AVSessionManager.AVCastCategory.CATEGORY_REMOTE;
      })
    })
    if (castDeviceIndex < 0) {
      this.castingSessionLink.set(undefined);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', {name: 'castingSessionInfo', value: undefined});
      }
    }
    for (let i = 0; i < descriptors.length; i++) {
      let aliveSessionDes: AVSessionManager.AVSessionDescriptor = descriptors[i];
      const sessionId = aliveSessionDes.sessionId;
      // 通话卡片
      if (aliveSessionDes.type === 'voice_call' || aliveSessionDes.type === 'video_call') {
        let isVoip: boolean = await this.isVoipSession(aliveSessionDes.elementName?.bundleName);
        log.showInfo(`bundle ${aliveSessionDes.elementName?.bundleName}, isVoip ${isVoip}`)
        if (!isVoip) {
          continue;
        }
        callSession = sessionId;
        callSessionListCache.push(sessionId);
        this.bundleNameMap[sessionId] = aliveSessionDes.elementName?.bundleName;
        if (this.bundleNameMap[sessionId] === Constants.MEET_SERVICE_SCENE.bundleName) {
          // 畅联
          this.abilityNameMap[sessionId] = Constants.MEET_SERVICE_SCENE.abilityName;
        } else {
          this.abilityNameMap[sessionId] = aliveSessionDes.elementName?.abilityName;
        }
        if (aliveSessionDes.elementName?.bundleName === Constants.MEET_SERVICE_SCENE.bundleName) { // 畅联
          this.phoneSession = undefined;
        }
        let bundleInfo: ShowingBundleTS = await this.getIconWithOnlyBundle(aliveSessionDes.elementName?.bundleName);
        let callInfo: CallSessionInfo = {
          sessionId: sessionId,
          appIcon: bundleInfo.pixelData,
          appName: bundleInfo.appName,
        }
        this.voipSession = callInfo;
        let hasCallValue: boolean = !!(this.phoneSession || callInfo) && !ControlCenterPluginMgr.isPcMode; // 非pc模式为true
        log.showInfo(`doSessionCollection, setCall ${hasCallValue}, hasPhone ${!!this.phoneSession}, hasVoip ${!!callInfo}`);
        this.setCallSession(hasCallValue, this.phoneSession || callInfo);
        continue;
      }
      // 媒体卡片
      let tempDescriptor = aliveSessionDes.sessionId;
      tempDescriptor = tempDescriptor && tempDescriptor?.length < 10 ? '' : (tempDescriptor?.substr(0, 5) +
        '**' + tempDescriptor?.substr(tempDescriptor?.length - 5));
      log.showInfo(' aliveSessionDes details:' + JSON.stringify(tempDescriptor));
      let isVideo: boolean = (aliveSessionDes.type == 'video');
      let isAudio: boolean = (aliveSessionDes.type == 'audio');
      this.isActive = aliveSessionDes.isActive;
      this.sessionTypeMap[sessionId] = isVideo;
      this.sessionTypeAudioMap[sessionId] = isAudio;
      this.avSessionDescriptorMap[sessionId] = aliveSessionDes;
      if (this.enableDc) {
        messageChannel.sendMessage('syncSessionData', { sessionId, descriptor: aliveSessionDes });
      }

      let controllerTemp: AVSessionManager.AVSessionController | undefined = await this.createNewController(sessionId);
      if (!controllerTemp) {
        continue;
      }
      sessionList.push(sessionId);
      this.bundleNameMap[sessionId] = aliveSessionDes.elementName?.bundleName;
      this.abilityNameMap[sessionId] = aliveSessionDes.elementName?.abilityName;
      // 设置投播session
      if (castDeviceIndex !== i) {
        continue;
      }
      const castDevice = aliveSessionDes.outputDevice.devices.find((device: AVSessionManager.DeviceInfo) => {
        return device.castCategory === AVSessionManager.AVCastCategory.CATEGORY_REMOTE;
      })
      if (castDevice) {
        let castSession: CastingSessionInfo = {
          sessionId: aliveSessionDes.sessionId,
          deviceName: castDevice.deviceName,
          deviceType: castDevice.deviceType,
          deviceId: castDevice.deviceId
        };
        this.castingSessionLink.set(castSession);
        if (this.enableDc) {
          messageChannel.sendMessage('syncAppStorage', {name: 'castingSessionInfo', value: castSession});
        }
      }
    }
    this.callSessionListCache = callSessionListCache;
    if (this.callSessionListCache.length === 0) {
      this.voipSession = undefined;
      let hasCallValue: boolean = !!this.phoneSession && !ControlCenterPluginMgr.isPcMode; // 非pc模式为true
      log.showInfo(`no voip session, setCall ${hasCallValue}, hasPhone ${!!this.phoneSession}`);
      this.setCallSession(hasCallValue, this.phoneSession);
    }
    if (sessionList.length >= Constants.SESSION_LIST_SIZE_LIMIT_NUM) {
      this.refreshSessionList(sessionList);
      return;
    }
    let historicalDescriptors: Array<AVSessionManager.AVSessionDescriptor> | undefined = undefined;
    try {
      log.showInfo('doSessionCollection  getHistoricalSessionDescriptors')
      historicalDescriptors =
        await AVSessionManager.getHistoricalSessionDescriptors(Constants.SESSION_LIST_SIZE_LIMIT_NUM);
    } catch (err) {
      log.error('fail to get historicalDescriptors:', err)
    }
    if (!historicalDescriptors) {
      this.refreshSessionList(sessionList);
      return;
    }
    for (let i = 0; i < historicalDescriptors.length; i++) {
      let historicalSessionDes: AVSessionManager.AVSessionDescriptor = historicalDescriptors[i];
      if (sessionList.includes(historicalSessionDes.sessionId)) {
        log.showInfo(`history exist : ${historicalSessionDes.sessionId?.length < 10 ? '' :
          (historicalSessionDes.sessionId?.substr(0, 5) + '**' +
          historicalSessionDes.sessionId?.substr(historicalSessionDes.sessionId?.length - 5))}`);
        continue;
      }
      if (this.stopVideoSessionList.includes(historicalSessionDes.sessionId)) {
        log.showInfo(`stop video session exist : ${historicalSessionDes.sessionId?.length < 10 ? '' :
          (historicalSessionDes.sessionId?.substr(0, 5) + '**' +
          historicalSessionDes.sessionId?.substr(historicalSessionDes.sessionId?.length - 5))}`);
        continue;
      }
      if (callSession === historicalSessionDes.sessionId ||
      this.callSessionListCache.includes(historicalSessionDes.sessionId)) {
        log.showInfo(`call session exist : ${historicalSessionDes.sessionId?.length < 10 ? '' :
          (historicalSessionDes.sessionId?.substr(0, 5) + '**' +
          historicalSessionDes.sessionId?.substr(historicalSessionDes.sessionId?.length - 5))}`);
        continue;
      }
      this.avSessionDescriptorMap[historicalSessionDes.sessionId] = historicalSessionDes;
      if (this.enableDc) {
        // 通知子线程
        messageChannel.sendMessage('syncSessionData', {
          sessionId: historicalSessionDes.sessionId, descriptor: historicalSessionDes
        });
      }
      sessionList.push(historicalSessionDes.sessionId);
      this.bundleNameMap[historicalSessionDes.sessionId] = historicalSessionDes.elementName?.bundleName;
      this.abilityNameMap[historicalSessionDes.sessionId] = historicalSessionDes.elementName?.abilityName;
    }
    this.refreshSessionList(sessionList);
  }

  private topSessionChangeCallback = async (session: AVSessionManager.AVSessionDescriptor) => {
    log.showInfo(`topSessionChange: ${session.type}, ${session.isTopSession}, ${session.sessionTag}`);
    this.topSessionId = session.sessionId;
    if (!DeviceHelper.isPC() && !!session.isTopSession) {
      AppStorage.setOrCreate('MediaType', session.type);
    }
    CommunicationUtil.doLocalEventNotify('topSessionChangeHis', session.sessionId);
  }

  private sessionCreateCallback = async (session: AVSessionManager.AVSessionDescriptor) => {
    const isColdStarting = globalStorage.getBooleanByKey('isColdStarting');
    log.showInfo(`on sessionCreate: ${session.sessionId?.length < 10 ? '' : (session.sessionId?.substr(0, 5) + '**' +
    session.sessionId?.substr(session.sessionId?.length - 5))}, ${isColdStarting}, ${session.sessionTag}`);
    this.avSessionDescriptorMap[session.sessionId] = session;
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSessionData', { sessionId: session.sessionId, descriptor: session });
    }
    this.bundleNameMap[session.sessionId] = session.elementName?.bundleName;
    if (this.bundleNameMap[session.sessionId] === Constants.MEET_SERVICE_SCENE.bundleName) {
      // 畅联
      this.abilityNameMap[session.sessionId] = Constants.MEET_SERVICE_SCENE.abilityName;
    } else {
      this.abilityNameMap[session.sessionId] = session.elementName?.abilityName;
    }
    // 通话session
    if (session.type === 'voice_call' || session.type === 'video_call') {
      let isVoip: boolean = await this.isVoipSession(session.elementName?.bundleName);
      log.showInfo(`create session ${session.elementName?.bundleName}, isVoip ${isVoip}`);
      if (!isVoip) {
        return;
      }
      if (session.elementName?.bundleName === Constants.MEET_SERVICE_SCENE.bundleName) { // 畅联
        this.phoneSession = undefined;
      }
      let bundleInfo: ShowingBundleTS = await this.getIconWithOnlyBundle(session.elementName?.bundleName);
      let callInfo: CallSessionInfo = {
        sessionId: session.sessionId,
        appIcon: bundleInfo.pixelData,
        appName: bundleInfo.appName,
      }
      this.voipSession = callInfo;
      let hasCallValue: boolean = !!callInfo && !ControlCenterPluginMgr.isPcMode; // 非pc模式为true
      log.showInfo(`create voip, setCall ${hasCallValue}, hasVoip ${!!callInfo}`);
      this.setCallSession(hasCallValue, callInfo);
      this.callSessionListCache.unshift(session.sessionId);
      return;
    }
    await this.createNewController(session.sessionId);
    log.showInfo('on sessionCreate, start controller done');
    let alreadyExist: boolean = false;
    let oldSessionId: string = '';
    let sessionList: string[] = this.sessionListCache;
    for (let i = 0; i < Constants.SESSION_LIST_SIZE_LIMIT_NUM; i++) {
      const checkSessionId = sessionList[i];
      if (checkSessionId && session.elementName.bundleName == this.bundleNameMap[checkSessionId] &&
        session.elementName.abilityName == this.abilityNameMap[checkSessionId]) {
        alreadyExist = true;
        oldSessionId = checkSessionId;
        break;
      }
    }
    log.showInfo(`on sessionCreate, alreadyExist: ${alreadyExist}`);
    // if already exist app session, put it at old place
    if (alreadyExist) {
      // remove new session id from list
      let sessionIndexForNew: number = sessionList.indexOf(session.sessionId);
      if (sessionIndexForNew >= 0) {
        sessionList.splice(sessionIndexForNew, 1);
      }
      // place new session in old place
      const sessionIndex: number = sessionList.indexOf(oldSessionId);
      sessionList[sessionIndex] = session.sessionId;
    } else {
      sessionList.push(session.sessionId);
    }
    if (sessionList.length > 1) {
      sessionList = sessionList.filter((session: string) => {
        return session !== 'default';
      });
    }
    // refresh session list
    this.refreshSessionList(sessionList);
    // notify session create event
    CommunicationUtil.doLocalEventNotify('sessionChanged', session.sessionId);
  }

  async isVoipSession(bundleName?: string): Promise<boolean> {
    if (!bundleName) {
      return false;
    }
    if (bundleName === Constants.MEET_SERVICE_SCENE.bundleName || bundleName === Constants.WELINK_BUNDLE_NAME) {
      return true;
    }
    let bundleCategory: BundleCategoryInfo | undefined = this.bundleCategoryMap.get(bundleName);
    if (bundleCategory === undefined) {
      // 权限验证
      let isOsAccountUnlocked: boolean = await this.checkAccountUnlocked();
      if (!isOsAccountUnlocked) {
        return false;
      }
      // let categoryResult: appInfoManager.AppCategoryInfo[] = [];
      try {
        // categoryResult = await appInfoManager.getAppCategory([bundleName]) || [];
        log.showInfo(`getAppCategory done with ${bundleName}`);
      } catch (err) {
        log.showInfo(`getAppCategory error ${err?.code}, ${err?.message}`);
        return false;
      }
      // if (categoryResult.length === 0) {
      //   return false;
      // }
      // let category: appInfoManager.AppCategoryInfo = categoryResult[0];
      // if (category.appQueryCode === appInfoManager.QueryCode.SUCCESS) {
      //   bundleCategory = {
      //     primaryCategoryId: category.primaryCategoryId,
      //     secondaryCategoryId: category.secondaryCategoryId,
      //   }
      //   this.bundleCategoryMap.set(bundleName, bundleCategory);
      // }
    }
    // 社交与商务分类
    if (bundleCategory?.primaryCategoryId === Constants.BUNDLE_MAIN_CATEGORY_APP &&
      (bundleCategory?.secondaryCategoryId === Constants.BUNDLE_SUB_CATEGORY_BUSINESS ||
        bundleCategory?.secondaryCategoryId === Constants.BUNDLE_SUB_CATEGORY_SOCIAL)) {
      return true;
    }
    return false;
  }

  async checkAccountUnlocked(): Promise<boolean> {
    if (this.isOsAccountUnlocked) {
      return true;
    }
    try {
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      let isVerified: boolean = await accountManager.isOsAccountUnlocked();
      log.showInfo(`isOsAccountUnlocked ${isVerified}`)
      this.isOsAccountUnlocked = isVerified;
    } catch (err) {
      log.showInfo(`isOsAccountUnlocked error ${err?.code}, ${err?.message}`);
      this.isOsAccountUnlocked = false;
    }
    return this.isOsAccountUnlocked;
  }

  setCallSession(hasCallValue: boolean, callInfo?: CallSessionInfo) {
    log.showInfo(`setCallSession ${hasCallValue}, phone ${!!this.phoneSession}, voip ${!!this.voipSession}, name ${callInfo?.appName}`);
    this.hasCallLink.set(hasCallValue);
    CommunicationUtil.doLocalEventNotify('callStateChange', hasCallValue);
    this.callSessionLink.set(callInfo);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncAppStorage', {name: 'hasCall', value: hasCallValue});
      messageChannel.sendMessage('syncAppStorage', {name: 'callSessionInfo', value: callInfo});
    }
  }

  private sessionDestroyCallback = async (session: AVSessionManager.AVSessionDescriptor) => {
    log.showInfo(`on sessionDestroy, session: ${session.sessionId?.length < 10 ? '' :
      (session.sessionId?.substr(0, 5) + '**' + session.sessionId?.substr(session.sessionId?.length - 5))}`);
    // 通话session
    if (session.type === 'voice_call' || session.type === 'video_call') {
      this.bundleNameMap[session.sessionId] = '';
      this.abilityNameMap[session.sessionId] = '';
      this.callSessionListCache = this.callSessionListCache.filter((item: string) => {
        return item !== session.sessionId;
      });
      let voipSessionId: string | undefined = this.callSessionListCache[0];
      let callInfo: CallSessionInfo | undefined = undefined;
      if (voipSessionId) {
        let bundleInfo: ShowingBundleTS = await this.getIconWithOnlyBundle(this.bundleNameMap[voipSessionId]);
        callInfo = bundleInfo ? {
          sessionId: voipSessionId,
          appIcon: bundleInfo.pixelData,
          appName: bundleInfo.appName,
        } : undefined;
      }
      this.voipSession = callInfo;
      let hasCallValue: boolean = !!(this.phoneSession || callInfo) && !ControlCenterPluginMgr.isPcMode; // 非pc模式为true
      log.showInfo(`destroy voip, setCall ${hasCallValue}, hasPhone ${!!this.phoneSession}, hasVoip ${!!callInfo}`);
      this.setCallSession(hasCallValue, this.phoneSession || callInfo);
      this.doSessionCollection();
      return;
    }
    let tempDes: AVSessionManager.AVSessionDescriptor = this.avSessionDescriptorMap[session.sessionId];
    if (this.sessionListLink) {
      let sessionList: string[] = JSON.parse(JSON.stringify(this.sessionListLink.get()));
      let sessionIndexInside: number = sessionList.indexOf(session.sessionId);
      log.showInfo(`on sessionDestroy, sessionList: ${sessionList.length}`);
      sessionList.splice(sessionIndexInside, 1);
      let callSessionIndex = this.callSessionListCache.indexOf(session.sessionId);
      if (callSessionIndex >= 0) {
        this.callSessionListCache.splice(callSessionIndex, 1);
      }
      this.avSessionControllerMap.get(session.sessionId)?.off('playbackStateChange');
      this.avSessionControllerMap.get(session.sessionId)?.off('outputDeviceChange');
      this.bundleNameMap[session.sessionId] = '';
      this.abilityNameMap[session.sessionId] = '';
      this.avSessionDescriptorMap[session.sessionId] = '';
      if (this.enableDc) {
        // 通知子线程
        messageChannel.sendMessage('syncSessionData', { sessionId: session.sessionId, descriptor: '' });
      }
      this.avSessionControllerMap.delete(session.sessionId);
      this.sessionPcmCastMap.delete(session.sessionId);
    }
    CommunicationUtil.doLocalEventNotify('sessionDestroy', session.sessionId);
    this.doSessionCollection();
    log.showInfo(`on sessionDestroy done, session: ${session.sessionId?.length < 10 ? '' :
      (session.sessionId?.substr(0, 5) + '**' + session.sessionId?.substr(session.sessionId?.length - 5))}`);
  }

  private callStateChangeCallback = async (data: observer.CallStateInfo) => {
    log.showInfo(`media center callStateChange ${data?.state}`);
    if (!data) {
      return;
    }
    if (data.state === call.CallState.CALL_STATE_UNKNOWN ||
      data.state === call.CallState.CALL_STATE_IDLE) {
      // 未在通话
      this.phoneSession = undefined;
      let hasCallValue = !!this.voipSession && !ControlCenterPluginMgr.isPcMode;
      log.showInfo(`destroy phone, setCall ${hasCallValue}, hasVoip ${!!this.voipSession}`);
      this.setCallSession(hasCallValue, this.voipSession);
    } else if (!this.phoneSession) {
      // 通话中
      let bundleInfo: ShowingBundleTS = await this.getIconWithOnlyBundle(Constants.PHONE_CALL_SCENE.bundleName);
      // 蜂窝通话
      let callInfo: CallSessionInfo = { sessionId: '', appIcon: bundleInfo.pixelData }
      this.phoneSession = callInfo;
      let hasCallValue: boolean = !!callInfo && !ControlCenterPluginMgr.isPcMode; // 非pc模式为true
      log.showInfo(`create phone, setCall ${hasCallValue}, hasPhone ${!!callInfo}`);
      this.setCallSession(hasCallValue, callInfo);
    }
  }

  /**
   * 注册serviceDie监听
   */
  registerServiceDie() {
    AVSessionManager.on('sessionServiceDie', () => {
      log.showInfo(`on sessionServiceDie clear`);
    });
  }

  /**
   * 注册session监听
   */
  registerSessionListener() {
    log.showInfo('registerSessionListener in ');
    SessionInfoProvider.on('sessionServiceDie', this.getServiceDieCallback());
    AVSessionManager.on('topSessionChange', this.topSessionChangeCallback);
    AVSessionManager.on('sessionCreate', this.sessionCreateCallback);
    AVSessionManager.on('sessionDestroy', this.sessionDestroyCallback);
    this.registerServiceDie();
    CastDeviceManager.on('outputDeviceChanged', this.getOutputDeviceCallback());
    observer.on('callStateChange', this.callStateChangeCallback);
    this.setOnDeviceStateListener();
  }

  private onDeviceStateChangedCallback = (state: CastDeviceState) => {
    log.showInfo(`deviceStateChanged: ${state.deviceState}`);
    this.deviceState = state.deviceState
  }

  setOnDeviceStateListener() {
    if (this.hasOnDeviceStateChanged) {
      return;
    }
    log.showInfo('setOnDeviceStateListener');
    this.hasOnDeviceStateChanged = true;
    onDeviceStateChanged('deviceStateChanged', this.onDeviceStateChangedCallback);
  }

  removeOnDeviceStateListener() {
    if (this.hasOnDeviceStateChanged) {
      log.showInfo('removeOnDeviceStateListener');
      this.hasOnDeviceStateChanged = false;
      try {
        offDeviceStateChanged('deviceStateChanged', this.onDeviceStateChangedCallback);
      } catch (err) {
        log.error('AVSessionManager off sessionCreate:', err);
      }
    }
  }

  /**
   * 释放provider实例的资源
   * @param message
   */
  static releaseProvider(message?: string) {
    log.showInfo('sessionInfo task release');
    if (SessionInfoProvider.provider) {
      SessionInfoProvider.provider.release(message);
    }
    SessionInfoProvider.provider = null;
  }

  /**
   * 释放资源
   * @param message
   */
  release(message?: string) {
    log.showInfo('provider release')
    SessionInfoProvider.isQuiting = true;
    let sessionList: string[] = this.sessionListCache;
    let hasSessionAlive: boolean = false;
    if (this.sessionListLink.get().length > 0) {
      sessionList = this.sessionListLink.get();
    }
    for (let i = 0; i < sessionList.length; i++) {
      if (this.avSessionControllerMap.get(sessionList[i])) {
        hasSessionAlive = true;
        this.avSessionControllerMap.get(sessionList[i])?.destroy();
      }
    }
    if (!hasSessionAlive && !globalStorage.getBooleanByKey('isTabletDevice')) {
      log.warn(`release with no alive session set discoverable`);
      AVSessionManager.setDiscoverable(false);
    }
    log.showInfo('sessionInfo cache clear')
    this.avSessionControllerMap.clear();
    this.sessionPcmCastMap.clear();
    this.avSessionDescriptorMap = new Map<string, AVSessionManager.AVSessionDescriptor>();
    this.bundleNameMap = new Map<string, string>();
    this.abilityNameMap = new Map<string, string>();
    try {
      AVSessionManager.off('sessionCreate');
    } catch (err) {
      log.error('AVSessionManager off sessionCreate:', err);
    }
    try {
      AVSessionManager.off('sessionDestroy');
    } catch (err) {
      log.error('AVSessionManager off sessionDestroy:', err);
    }
    try {
      AVSessionManager.off('sessionServiceDie');
    } catch (err) {
      log.error('AVSessionManager off sessionServiceDie:', err);
    }
    log.showInfo('session task release done ')
    CastDeviceManager.off('outputDeviceChanged', this.getOutputDeviceCallback());
    observer.off('callStateChange', this.callStateChangeCallback);
  }

  /**
   * 获取投播cast controller
   * @param sessionId
   * @returns
   */

  private async refreshCurRemoteDeviceSelectLink(sessionId: string, state: AVSessionManager.ConnectionState,
    device?: AVSessionManager.OutputDeviceInfo): Promise<void> {
    // 获取投播cast controller
    if (!sessionId || sessionId != this.targetSessionId) {
      log.showInfo('refreshCurRemoteDeviceSelectLink with not target session, return');
      return;
    }
    if (state === AVSessionManager.ConnectionState.STATE_CONNECTED &&
      device?.devices?.[0]?.castCategory !== AVSessionManager.AVCastCategory.CATEGORY_LOCAL &&
      device?.devices?.[0]?.deviceName !== 'RemoteCast') {
      AppStorage.setOrCreate('CurRemoteDevSelect', device?.devices?.[0]?.deviceType);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', {name: 'CurRemoteDevSelect',
          value: device?.devices?.[0]?.deviceType});
      }
    }
    if (state === AVSessionManager.ConnectionState.STATE_DISCONNECTED ||
      device?.devices?.[0]?.castCategory === AVSessionManager.AVCastCategory.CATEGORY_LOCAL) {
      AppStorage.setOrCreate('CurRemoteDevSelect', -1);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', {name: 'CurRemoteDevSelect', value: -1});
      }
    }
    CommunicationUtil.doLocalEventNotify('controllerChanged', sessionId);
  }

  public async findSessionInCasting() : Promise<string> {
    if (!this.sessionListCache?.length) {
      return '';
    }
    for (let i = 0; i < this.sessionListCache.length; i++) {
      const sessionId = this.sessionListCache[i];
      const isCastSession = await this.checkIsCastSession(sessionId);
      if (isCastSession) {
        return sessionId;
      }
    }
    return '';
  }

  public async checkIsCastSession(sessionId: string) {
    log.showInfo(`check Is Cast Session: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`)
    const controller: AVSessionManager.AVSessionController | undefined = this.avSessionControllerMap.get(sessionId);
    if (!controller) {
      log.error('check Is Cast Session fail: no controller')
      return false;
    }
    const outputDevInfo: AVSessionManager.OutputDeviceInfo = await controller.getOutputDevice();
    this.setIsPcmCast(sessionId, outputDevInfo);
    const localDeviceIndex = this.findDeviceCategoryIndex(outputDevInfo,
      [AVSessionManager.AVCastCategory.CATEGORY_LOCAL]);
    log.showInfo(`check Is Cast Session with outputDevInfo: ${localDeviceIndex}`);
    return !!outputDevInfo?.devices?.length && localDeviceIndex < 0;
  }

  private setIsPcmCast(sessionId: string, outputDevInfo: AVSessionManager.OutputDeviceInfo) {
    let protocols = outputDevInfo?.devices?.[0]?.supportedProtocols;
    const isPcmCast: boolean = !!protocols && (protocols & 8) !== 0;
    this.sessionPcmCastMap.set(sessionId, isPcmCast);
  }

  private findDeviceCategoryIndex(outputDevInfo: AVSessionManager.OutputDeviceInfo,
                                  castCategory: AVSessionManager.AVCastCategory[]) {
    let result = -1;
    if (!outputDevInfo) {
      return result;
    }
    const outputDevList: AVSessionManager.DeviceInfo[] = outputDevInfo.devices;
    if (!outputDevList || outputDevList.length <= 0) {
      return result;
    }
    for (let i = 0; i < outputDevList.length; i++) {
      const outputDev: AVSessionManager.DeviceInfo = outputDevList[i];
      log.debug(`get device with category index: ${outputDev.castCategory}, ${castCategory.includes(outputDev.castCategory)} -> ${i}}`);
      if (castCategory.includes(outputDev.castCategory)) {
        return i;
      }
    }
    return result;
  }

  private async getAVCastControllerInner(sessionId: string): Promise<AVSessionManager.AVCastController | undefined> {
    try {
      log.showInfo(`try get av cast controller: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
        sessionId?.substr(sessionId?.length - 5))}`);
      const castController: AVSessionManager.AVCastController =
        await AVSessionManager.getAVCastController(sessionId);
      return castController;
    } catch (err) {
      log.error('fail to get cast controller:', err);
      return undefined;
    }
  }

  public async getCurrentScenesType(): Promise<ScenesType> {
    let scenesType: string | undefined = globalStorage.getStringByKey('scenesType');
    let controlCenterShowDev: boolean = globalStorage.getBooleanByKey('controlCenterShowDev');
    log.showInfo(`getCurrentScenesType scenes type is: ${scenesType},${controlCenterShowDev}`);
    const currentSession: string = this.topSessionId;
    if (currentSession === '') {
      return ScenesType.SCENES_MEDIA_CONTROL;
    }
    let isCastController: AVSessionManager.AVCastController | undefined = undefined;
    try {
      isCastController = await AVSessionManager.getAVCastController(currentSession);
    } catch (err) {
      log.showInfo(`scenesType is local`)
    }
    if (!isCastController) {
      if (scenesType === 'controlCenter' || controlCenterShowDev) {
        if (controlCenterShowDev) {
          globalStorage.setBooleanByKey('controlCenterShowDev', false);
        }
        return ScenesType.SCENES_CONTROL_CENTER;
      } else if (scenesType === 'screenLock') {
        return ScenesType.SCENES_SCREEN_LOCK;
      } else if (scenesType === 'notify') {
        return ScenesType.SCENES_NOTIFICATION;
      } else if (scenesType === 'capsule') {
        return ScenesType.SCENES_SCREEN_LOCK_CAPSULE;
      } else if (scenesType === 'immersive') {
        return ScenesType.SCENES_SCREEN_LOCK_IMMERSIVE;
      } else if (scenesType === 'cover') {
        return ScenesType.SCENES_COVER_LOCK;
      } else if (scenesType === 'expandMediaInfoCard') {
        return ScenesType.SCENES_EXPAND_MEDIA_CARD;
      }
      return ScenesType.SCENES_MEDIA_CONTROL;
    }
    const descriptor: AVSessionManager.AVSessionDescriptor | undefined = this.avSessionDescriptorMap[currentSession];
    if (descriptor?.sessionTag === 'RemoteCast') {
      return ScenesType.SCENES_MEDIA_CONTROL_SINK;
    } else {
      return ScenesType.SCENES_MEDIA_CONTROL_SOURCE;
    }
  }

  public reportScenesHiEvent(eventType: EventType, dfxParam: DfxParam | RadarParam, isUE:boolean,
                             reportEvent?: boolean): void {
    this.getCurrentScenesType().then((scenesType:ScenesType) => {
      HiSysEvent.getEventParam(eventType)
        .updateScenes(scenesType)
        .updateAllExtendParam(dfxParam)
        .reportEvent(isUE, reportEvent);
    })
  }

  async getUserId() {
    if (!!this.userId) {
      return this.userId;
    }
    const osAccountManager = osAccount.getAccountManager();
    let userId: number = 0;
    try {
      userId = await osAccountManager.getOsAccountLocalId();
      log.showInfo(`getOsAccountLocalId localId: ${userId}`);
    } catch (err) {
      log.error(`getUserId by elementName err : ${err}`);
    }
    this.userId = userId;
    return userId;
  }

  /**
   * 获取需要显示的应用信息，logo图标，应用名称
   * @param bundleName
   * @param userId
   * @param sessionId
   * @returns
   */
  async getShowingBundle(bundleName: string, abilityName: string): Promise<string | PixelMap | boolean | undefined> {
    log.showInfo(`try get appIcon: ${bundleName}, ${abilityName}`);
    let appIcon: string | PixelMap | boolean | undefined = undefined;
    if (!bundleName) {
      log.showError(`get appIcon fail: invalid bundleName`);
      return appIcon;
    }
    try {
      let moduleName = '';
      if (this.appModuleMap.has(bundleName) && this.appVersionMap.get(bundleName)) {
        log.showInfo(`get moduleName from catch`);
        moduleName = this.appModuleMap.get(bundleName) || '';
      } else {
        const userId: number = await AccountMgr.getCurrentAccountId();
        let bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoSync(bundleName,
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY, userId);
        this.appVersionMap.set(bundleName, bundleInfo.versionName);
        let appRes: resourceManager.Resource = bundleInfo?.appInfo?.iconResource;
        moduleName = appRes?.moduleName;
      }
      if (!moduleName) {
        log.showError(`get appIcon fail: invalid moduleName`);
        moduleName = 'entry';
      }
      this.appModuleMap.set(bundleName, moduleName);
      let iconResource: string | PixelMap = await IconResourceManager.getInstance().getCombIcon(bundleName, moduleName,
        abilityName, undefined, 'CombIcon_SessionInfoProvider');
      if (!CheckEmptyUtils.isEmpty(iconResource)) {
        log.showInfo(`get appIcon success`);
        appIcon = iconResource;
      }
    } catch (err) {
      log.error('get app icon by elementName err :', err);
    }
    return appIcon;
  }

  async getBundleInfoForSession(sessionId: string): Promise<bundleManager.BundleInfo> {
    let bundleName: string = this.bundleNameMap[sessionId];
    let userId = await this.getUserId();
    let bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoSync(bundleName,
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY, userId);
    return bundleInfo;
  }

  /**
   * 获取需要显示的应用信息，logo图标，应用名称
   * @param bundleName
   * @param userId
   * @param sessionId
   * @returns
   */
  async getIconWithOnlyBundle(bundleName: string): Promise<ShowingBundleTS> {
    log.showInfo(`getIconWithOnlyBundle, bundleName: ${bundleName}`)
    let result: ShowingBundleTS = {
      appName: this.appNameMap.get(bundleName)
    }
    try {
      if (!result.appName) {
        let userId = await this.getUserId();
        log.showInfo(`getIconWithOnlyBundle userId: ${userId}`);
        const bundleInfo: bundleManager.BundleInfo | undefined | null = bundleManager.getBundleInfoSync(bundleName,
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY, userId);
        const context: Context | undefined = GlobalContext.getInstance().getObject('desktopContext') as Context;
        const bundleContext: Context = context?.createBundleContext(bundleName);
        const labelId: number = bundleInfo?.appInfo?.labelId;
        const newAppName: string = await bundleContext?.resourceManager.getStringValue(labelId);
        this.appNameMap.set(bundleName, newAppName);
        result.appName = newAppName;
      }
      result.pixelData = await IconResourceManager.getInstance().getCombIcon(bundleName);
    } catch (err) {
      log.error('getIconWithOnlyBundle err:', err);
    }
    log.showInfo(`getIconWithOnlyBundle, return ${result.appName}`)
    return result;
  }

  getOutputDeviceCallback(): LocalEventCallback {
    if (!this.outputDeviceCallback) {
      this.outputDeviceCallback = new LocalEventCallback(async (message: DeviceSession) => {
        if (!message) {
          log.error(`get event callback without message`);
          return;
        }
        const sessionId: string = message.sessionId;
        const connectState: number = message.connectState;
        this.setIsPcmCast(sessionId, message.device);
        CommunicationUtil.doLocalEventNotify('controllerChanged', sessionId);
      });
    }
    return this.outputDeviceCallback;
  }

  getServiceDieCallback(): LocalEventCallback {
    if (!this.serviceDieCallback) {
      this.serviceDieCallback = new LocalEventCallback(async (message: DeviceSession) => {
        log.showInfo(`serviceDie callback`)
        try {
          AVSessionManager.off('topSessionChange', this.topSessionChangeCallback);
        } catch (err) {
          log.error('AVSessionManager off topSessionChange error');
        }
        try {
          AVSessionManager.off('sessionCreate', this.sessionCreateCallback);
        } catch (err) {
          log.error('AVSessionManager off sessionCreate error');
        }
        try {
          AVSessionManager.off('sessionDestroy', this.sessionDestroyCallback);
        } catch (err) {
          log.error('AVSessionManager off sessionDestroy error');
        }
        this.removeOnDeviceStateListener();
        this.avSessionControllerMap.clear();
        this.sessionPcmCastMap.clear();
        this.avSessionDescriptorMap = new Map<string, AVSessionManager.AVSessionDescriptor>();
        AVSessionManager.on('topSessionChange', this.topSessionChangeCallback);
        AVSessionManager.on('sessionCreate', this.sessionCreateCallback);
        AVSessionManager.on('sessionDestroy', this.sessionDestroyCallback);
        this.setOnDeviceStateListener();
      });
    }
    return this.serviceDieCallback;
  }
}