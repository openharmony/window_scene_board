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
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { ScreenLockEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { sEventManager } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import { obtainLocalEvent } from '@ohos/frameworkwrapper/src/main/ets/utils/EventUtil';
import common from '@ohos.app.ability.common';
import AVSessionManager from '@ohos.multimedia.avsession';
import image from '@ohos.multimedia.image';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import Constants, {
  AVQueueInfo,
  LocalDeviceInfo,
  SyncSubDataInfo,
  SyncSessionListInfo,
  SyncIsSinkSessionInfo,
  SyncGlobalStorageInfo,
  SyncRecommendCollectInfo,
  SyncLocalNotifyInfo,
  SyncSessionDataInfo,
  SyncDeviceListDataInfo,
  SyncAppStorageInfo,
  QuitSubWindowInfo,
  MediaInfoData,
} from '../Util/Constants';
import { ControlCenterState } from '@ohos/controlcentercommon/src/main/ets/common/ControlCenterConstants';
import { globalStorage } from '../Util/GlobalStorage';
import CommunicationUtil from '../Util/CommunicationUtil';
import { ShowingMesTS } from './CardMediaController';
import sControlCenterScreenLockController from '@ohos/controlcentercommon/src/main/ets/base/CommonScreenLockController';
import { MediaInfoListData } from '../viewmodel/MediaInfoListData';

const TAG = 'DcMediaController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export class DcMediaController {
  private static controller: DcMediaController | undefined = undefined;

  // 一级页面（CardMediaController）
  private controlMediaTitleLink: AbstractProperty<string | boolean | null>;
  private mediaTitleLink: AbstractProperty<string | boolean | null>;
  private mediaArtistLink: AbstractProperty<string | boolean | null>;
  private mediaDisplayTagsLink:AbstractProperty< number | null>;
  private mediaImgLink: AbstractProperty<boolean | string | image.PixelMap | null>;
  private mediaImgShowLink: AbstractProperty<boolean | null>;
  private mediaIconLink: AbstractProperty<boolean | string | image.PixelMap | null>;
  private appIconShowLink: AbstractProperty<boolean | null>;
  private mediaPlayStateLink: AbstractProperty<number | null>;
  private mediaEnableLink: AbstractProperty<boolean | null>;
  private appNameLink: AbstractProperty<string | boolean | null>;
  private mediaValidCommandsLink: AbstractProperty<Array<string>>;
  private mediaSkipIntervalsLink: AbstractProperty<number | null>;
  private mediaTypeLink: AbstractProperty<AVSessionManager.AVSessionType | null>;
  private mediaLoopModeLink: AbstractProperty<string | number | null>;
  private hasLyricLink: AbstractProperty<boolean>;
  private mediaSpeedLink: AbstractProperty<string | number | null>;
  private avQueueIdLink: AbstractProperty<string | null>;
  private playbackPositionLink: AbstractProperty<AVSessionManager.PlaybackPosition>;
  private isChangeSongLink: AbstractProperty<boolean>;
  private isFavorLink: AbstractProperty<boolean>;
  public static showingWant: Want | undefined = undefined;

  // 二级页面（MediaInfoProvider）
  private sessionListLink: AbstractProperty<Array<string>>;
  private metaDataMapLink: AbstractProperty<Map<string, AVSessionManager.AVMetadata>>;
  private imageRatioMapLink: AbstractProperty<Map<string, number>>; // 封面图比例
  private appIconMapLink: AbstractProperty<Map<string, image.PixelMap>>;
  private playStateMapLink: AbstractProperty<Map<string, AVSessionManager.AVPlaybackState>>;
  private commandEnableMapLink: AbstractProperty<Map<string, Array<AVSessionManager.AVControlCommandType>>>;
  private playbackPositionMapLink: AbstractProperty<Map<string, Object>>;
  private appNameMapLink: AbstractProperty<Map<string, string>>;
  private albumInfoListLink: AbstractProperty<Array<AVQueueInfo>>;
  private mediaInfoListDataLink: AbstractProperty<Array<MediaInfoListData>>;
  private isExistAvQueueInfoLink: AbstractProperty<boolean>;
  public static isSinkSession: boolean = false;
  public sessionListCache: string[] = [];

  // session信息（SessionInfoProvider）
  public avSessionDescriptorMap: Map<string, AVSessionManager.AVSessionDescriptor> =
    new Map<string, AVSessionManager.AVSessionDescriptor>();

  private mMergedDeviceListLink: AbstractProperty<Array<LocalDeviceInfo>>;
  private callDeviceListLink: AbstractProperty<Array<LocalDeviceInfo>>;

  constructor() {
    // 一级页面
    this.controlMediaTitleLink = AppStorage.setAndRef('ControlMediaTitle', null);
    this.mediaTitleLink = AppStorage.setAndRef('MediaTitle', null);
    this.mediaArtistLink = AppStorage.setAndRef('MediaArtist', null);
    this.mediaDisplayTagsLink = AppStorage.setAndRef('MediaDisplayTags', null);
    this.mediaImgLink = AppStorage.setAndRef('MediaImg', null);
    this.mediaImgShowLink = AppStorage.setAndRef('MediaImgShow', null);
    this.mediaIconLink = AppStorage.setAndRef('MediaIcon', null);
    this.appIconShowLink = AppStorage.setAndRef('appIconShow', null);
    this.mediaPlayStateLink = AppStorage.setAndRef('MediaPlayState', null);
    this.mediaEnableLink = AppStorage.setAndRef('MediaEnable', null);
    this.appNameLink = AppStorage.setAndRef('appName', null);
    this.mediaValidCommandsLink = AppStorage.setAndRef('MediaValidCommands', []);
    this.mediaSkipIntervalsLink = AppStorage.setAndRef('MediaSkipIntervals', null);
    this.mediaTypeLink = AppStorage.setAndRef('MediaType', null);
    this.mediaLoopModeLink = AppStorage.setAndRef('MediaLoopMode', null);
    this.hasLyricLink = AppStorage.setAndRef('hasLyric', false);
    this.mediaSpeedLink = AppStorage.setAndRef('MediaSpeed', 1);
    this.avQueueIdLink = AppStorage.setAndRef('CurAvQueueId', null);
    this.playbackPositionLink = AppStorage.setAndRef('playbackPosition', {elapsedTime: 0, updateTime: 0});
    this.isChangeSongLink = AppStorage.setAndRef('isChangeSong', false);
    this.isFavorLink = AppStorage.setAndRef('MediaIsFavor', false);

    // 二级页面
    let tempMetaDataMap: Map<string, AVSessionManager.AVMetadata> = new Map();
    this.metaDataMapLink = AppStorage.setAndRef('MetaDataMap', tempMetaDataMap);
    let tempImageRatioMap: Map<string, number> = new Map();
    this.imageRatioMapLink = AppStorage.setAndRef('imageRatioMap', tempImageRatioMap);
    let tempPlayStateMap: Map<string, AVSessionManager.AVPlaybackState> = new Map();
    this.playStateMapLink = AppStorage.setAndRef('PlayStateMap', tempPlayStateMap);
    let tempCommandEnableMap: Map<string, Array<AVSessionManager.AVControlCommandType>> = new Map();
    this.commandEnableMapLink = AppStorage.setAndRef('commandEnableMap', tempCommandEnableMap);
    let tempPlaybackPositionMap: Map<string, Object> = new Map();
    this.playbackPositionMapLink = AppStorage.setAndRef('playbackPositionMap', tempPlaybackPositionMap);
    let tempAppIconMap: Map<string, image.PixelMap> = new Map();
    this.appIconMapLink = AppStorage.setAndRef('appIconMap', tempAppIconMap);
    let appNameMap: Map<string, string> = new Map();
    this.appNameMapLink = AppStorage.setAndRef('appNameMap', appNameMap);
    this.sessionListLink = AppStorage.setAndRef('sessionList', []);
    this.albumInfoListLink = AppStorage.setAndRef('AlbumInfoList', []);
    this.mediaInfoListDataLink = AppStorage.setAndRef('mediaInfoListData', []);
    this.isExistAvQueueInfoLink = AppStorage.setAndRef('isExistAvQueueInfo', false);

    // 设备列表
    this.mMergedDeviceListLink = AppStorage.setAndRef('MergedDeviceList', []);
    this.callDeviceListLink = AppStorage.setAndRef('callDeviceList', []);
  }

  public static getInstance(): DcMediaController {
    if (!DcMediaController.controller) {
      DcMediaController.controller = new DcMediaController();
      DcMediaController.controller.init();
    }
    return DcMediaController.controller;
  }

  /**
   * 初始化
   */
  init() {
    // 一级页面（CardMediaController）
    messageChannel.onMessage('syncMediaData', this.syncMediaData); // 同步媒体信息
    messageChannel.onMessage('goSubWindow', this.goSubWindow); // 跳转二级页
    messageChannel.onMessage('quitSubWindow', this.quitSubWindow); // 退出二级页
    messageChannel.onMessage('syncGlobalStorage', this.syncGlobalStorage); // 同步globalStorage
    messageChannel.onMessage('syncRecommendInit', this.syncRecommendInit); // 同步推荐服务初始化
    messageChannel.onMessage('syncRecommendCollect', this.syncRecommendCollect); // 同步推荐服务
    EvtBus.on(ScreenLockEvent, this.onScreenLockCallback); // 灭屏亮屏
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {type: 'initCollectService'}); // 初始化推荐服务
    // 二级页面（MediaInfoProvider）
    messageChannel.onMessage('syncSubData', this.syncSubData); // 同步二級页信息
    messageChannel.onMessage('syncSessionList', this.syncSessionList); // 同步sessionList
    messageChannel.onMessage('syncIsSinkSession', this.syncIsSinkSession); // 同步sessionList
    messageChannel.onMessage('syncLocalNotify', this.syncLocalNotify); // 同步本地通知
    messageChannel.onMessage('syncAppStorage', this.syncAppStorage); // 同步AppStorage
    // session信息（SessionInfoProvider）
    messageChannel.onMessage('syncSessionData', this.syncSessionData); //同步session信息
    // 投播（CastDeviceManager）
    messageChannel.onMessage('syncDeviceListData', this.syncDeviceListData); // 同步设备列表
    // 折叠屏
    messageChannel.onMessage('syncMediaUpdate', this.syncMediaUpdate); // 同步通知信息

  }

  release() {
    // 一级页面（CardMediaController）
    messageChannel.offMessage('syncMediaData', this.syncMediaData); // 同步媒体信息
    messageChannel.offMessage('goSubWindow', this.goSubWindow); // 跳转二级页
    messageChannel.offMessage('quitSubWindow', this.quitSubWindow); // 退出二级页
    messageChannel.offMessage('syncGlobalStorage', this.syncGlobalStorage); // 同步globalStorage
    messageChannel.offMessage('syncRecommendInit', this.syncRecommendInit); // 同步推荐服务初始化
    messageChannel.offMessage('syncRecommendCollect', this.syncRecommendCollect); // 同步推荐服务
    EvtBus.off(ScreenLockEvent, this.onScreenLockCallback); // 灭屏亮屏
    // 二级页面（MediaInfoProvider）
    messageChannel.offMessage('syncSubData', this.syncSubData); // 同步二級页信息
    messageChannel.offMessage('syncSessionList', this.syncSessionList); // 同步sessionList
    messageChannel.offMessage('syncIsSinkSession', this.syncIsSinkSession); // 同步sessionList
    messageChannel.offMessage('syncLocalNotify', this.syncLocalNotify); // 同步本地通知
    messageChannel.offMessage('syncAppStorage', this.syncAppStorage); // 同步AppStorage
    // session信息（SessionInfoProvider）
    messageChannel.offMessage('syncSessionData', this.syncSessionData); // 同步session信息
    // 投播（CastDeviceManager）
    messageChannel.offMessage('syncDeviceListData', this.syncDeviceListData); // 同步设备列表
    // 折叠屏
    messageChannel.offMessage('syncMediaUpdate', this.syncMediaUpdate); // 同步通知信息

  }

  /**
   * 媒体信息变更
   */
  private syncMediaData = (mediaInfo: ShowingMesTS) => {
    if (mediaInfo.controlMediaTitle !== undefined) {
      this.controlMediaTitleLink.set(mediaInfo.controlMediaTitle);
    }
    if (mediaInfo.musicTitle !== undefined) {
      this.mediaTitleLink.set(mediaInfo.musicTitle);
    }
    if (mediaInfo.musicAuthor !== undefined) {
      this.mediaArtistLink.set(mediaInfo.musicAuthor);
    }
    this.mediaDisplayTagsLink.set(mediaInfo?.displayTags || null);
    if (mediaInfo.musicPic !== undefined || mediaInfo.isChangeApp) {
      if (!mediaInfo.musicPic) {
        this.mediaImgLink.set(undefined);
        this.mediaImgShowLink.set(false);
      } else if (typeof(mediaInfo.musicPic) === 'string' && mediaInfo.musicPic.startsWith(`http`)) {
        log.showInfo(`mediaInfo.musicPic: ${mediaInfo.musicPic}`);
      } else {
        this.mediaImgLink.set(mediaInfo.musicPic);
        this.mediaImgShowLink.set(true);
      }
    }
    if (mediaInfo.playState !== undefined) {
      this.mediaPlayStateLink.set(mediaInfo.playState);
    }
    if (mediaInfo.hasMedia !== undefined) {
      this.mediaEnableLink.set(mediaInfo.hasMedia);
    }
    if (mediaInfo.mediaPlayerIcon !== undefined || mediaInfo.isChangeApp) {
      if (!mediaInfo.mediaPlayerIcon) {
        this.mediaIconLink.set(undefined);
        this.appIconShowLink.set(false);
      } else {
        this.mediaIconLink.set(mediaInfo.mediaPlayerIcon);
        this.appIconShowLink.set(true);
      }
    }
    if (mediaInfo.appName !== undefined) {
      this.appNameLink.set(mediaInfo.appName);
    }
    if (mediaInfo.validCommands !== undefined) {
      this.mediaValidCommandsLink.set(mediaInfo.validCommands);
    }
    if (mediaInfo.isChangeSong !== undefined) {
      this.isChangeSongLink.set(mediaInfo.isChangeSong);
    }
    if (mediaInfo.skipIntervals !== undefined || mediaInfo.isChangeApp || mediaInfo.isChangeSong) {
      this.mediaSkipIntervalsLink.set(mediaInfo.skipIntervals);
    }
    if (mediaInfo.mediaType !== undefined) {
      this.mediaTypeLink.set(mediaInfo.mediaType);
    }
    if (mediaInfo.loopMode !== undefined) {
      this.mediaLoopModeLink.set(mediaInfo.loopMode);
    }
    if (mediaInfo?.lyric !== '' && mediaInfo?.lyric?.startsWith('[')) {
      this.hasLyricLink.set(true);
    } else if (mediaInfo?.lyric != undefined) {
      this.hasLyricLink.set(false);
    }
    if (mediaInfo.speed !== undefined ) {
      this.mediaSpeedLink.set(mediaInfo.speed);
    } else if (mediaInfo.isChangeApp || mediaInfo.isChangeSong) {
      this.mediaSpeedLink.set(1);
    }
    if (mediaInfo.avQueueId !== undefined) {
      log.showInfo(`controllerCallback avQueueId: ${mediaInfo.avQueueId}`)
      this.avQueueIdLink.set(mediaInfo.avQueueId);
    } else {
      log.showInfo(`controllerCallback avQueueId is undefined`);
      this.avQueueIdLink.set(undefined);
    }
    if (mediaInfo.position !== undefined) {
      this.playbackPositionLink?.set(mediaInfo.position);
    }
    if (mediaInfo.isFavor !== undefined) {
      this.isFavorLink.set(mediaInfo.isFavor);
    }
  }

  /**
   * 灭屏亮屏广播回调
   */
  private onScreenLockCallback = (event: ScreenLockEvent) => {
    log.showInfo(`onScreenLockCallback isScreenLock: ${event.isLockScreen}`);
    let isMediaCenterShow = GlobalContext.getInstance().getObject('isMediaCenterShow') ?? false;
    if (event.isLockScreen && isMediaCenterShow) {
      this.quitSubWindow({ hideWindow: true });
    }
  }

  /**
   * 跳转二级页
   * @param want
   */
  private goSubWindow = (want: Want) => {
    sControlCenterScreenLockController.handleOnControlCenterWithScreenLock(() => {
      DcMediaController.showingWant = want;
      GlobalContext.getInstance().setObject('isMediaCenterShow', true);
      sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MEDIA_CENTER));
    }, false);
  }

  /**
   * 退出二级页
   */
  private quitSubWindow = (data: QuitSubWindowInfo) => {
    if (data.hideWindow) {
      DropDownPanelManager.postRequestHideWindow(true);
    }
    GlobalContext.getInstance().setObject('isMediaCenterShow', false);
    sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MAIN_LAYOUT));
  }

  /**
   * 同步globalStorage
   */
  private syncGlobalStorage = (data: SyncGlobalStorageInfo) => {
    if (data.name === undefined || data.value === undefined) {
      return;
    }
    if (typeof data.value === 'number') {
      globalStorage.setNumberByKey(data.name, data.value);
    } else if (typeof data.value === 'string') {
      globalStorage.setStringByKey(data.name, data.value);
    } else if (typeof data.value === 'boolean') {
      globalStorage.setBooleanByKey(data.name, data.value);
    } else if (typeof data.value === 'object') {
      globalStorage.setGlobalObjectByKey(data.name, data.value);
    }
  }

  /**
   * 推荐服务初始化
   */
  private syncRecommendInit = () => {
    log.showInfo(`syncRecommendInit`);
  }

  /**
   * 同步推荐服务
   */
  private syncRecommendCollect = (data: SyncRecommendCollectInfo) => {

  }

  /**
   * 为主线程设置globalStorage
   */
  callGlobalStorage(data: SyncGlobalStorageInfo) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'callGlobalStorage', name: data.name, value: data.value,
    });
  }

  /**
   * 为主线程设置GlobalContext
   */
  callGlobalContext(data: SyncGlobalStorageInfo) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'callGlobalContext', name: data.name, value: data.value,
    });
  }

  /**
   * 二级页信息变更
   */
  private syncSubData = (data: SyncSubDataInfo) => {
    // 歌单
    if (data.albumInfoList !== undefined) {
      this.albumInfoListLink.set(data.albumInfoList);
      this.convertRecommendListData(data.albumInfoList);
    }
    if (data.mediaInfoListData !== undefined) {
      this.convertMediaInfoData(data.mediaInfoListData);
    }
    if (data.isExistAvQueueInfo !== undefined) {
      this.isExistAvQueueInfoLink.set(data.isExistAvQueueInfo);
    }
    if (!data.sessionId) {
      return;
    }
    // 删除session信息
    if (data.needRemove) {
      let metaDataMap: Map<string, AVSessionManager.AVMetadata> = this.metaDataMapLink.get();
      metaDataMap[data.sessionId] = undefined;
      this.metaDataMapLink.set(metaDataMap);
      let imageRatioMap: Map<string, number> = this.imageRatioMapLink.get();
      imageRatioMap[data.sessionId] = undefined;
      this.imageRatioMapLink.set(imageRatioMap);
      let appIconMap: Map<string, image.PixelMap> = this.appIconMapLink.get()
      appIconMap[data.sessionId] = undefined;
      this.appIconMapLink.set(appIconMap);
      let playStateMap: Map<string, AVSessionManager.AVPlaybackState> = this.playStateMapLink.get();
      playStateMap[data.sessionId] = undefined;
      this.playStateMapLink.set(playStateMap);
      let commandsMap: Map<string, Array<AVSessionManager.AVControlCommandType>> = this.commandEnableMapLink.get();
      commandsMap[data.sessionId] = undefined;
      this.commandEnableMapLink.set(commandsMap);
      let positionMap: Map<string, Object> = this.playbackPositionMapLink.get();
      positionMap[data.sessionId] = undefined;
      this.playbackPositionMapLink.set(positionMap);
      return;
    }
    // 更新session信息
    if (data.metadata !== undefined) {
      let metaDataMap: Map<string, AVSessionManager.AVMetadata> = this.metaDataMapLink.get();
      if (!this.checkUpdateImage(metaDataMap[data.sessionId], data.metadata)) {
        // 释放PixelMap内存
        this.clearPixelMapCache(metaDataMap[data.sessionId]);
      }
      metaDataMap[data.sessionId] = data.metadata;
      this.metaDataMapLink.set(metaDataMap);
    }
    if (data.imageRatio !== undefined) {
      let imageRatioMap: Map<string, number> = this.imageRatioMapLink.get();
      imageRatioMap[data.sessionId] = data.imageRatio;
      this.imageRatioMapLink.set(imageRatioMap);
    }
    if (data.playState !== undefined) {
      let playStateMap: Map<string, AVSessionManager.AVPlaybackState> = this.playStateMapLink.get();
      playStateMap[data.sessionId] = data.playState;
      this.playStateMapLink.set(playStateMap);
    }
    if (data.validCommands !== undefined) {
      let commandsMap: Map<string, Array<AVSessionManager.AVControlCommandType>> = this.commandEnableMapLink.get();
      commandsMap[data.sessionId] = data.validCommands;
      this.commandEnableMapLink.set(commandsMap);
    }
    if (data.appName !== undefined) {
      let appNameMap: Map<string, string> = this.appNameMapLink.get();
      appNameMap[data.sessionId] = data.appName;
      this.appNameMapLink.set(appNameMap);
    }
    if (data.position !== undefined) {
      let positionMap: Map<string, Object> = this.playbackPositionMapLink.get();
      positionMap[data.sessionId] = data.position;
      this.playbackPositionMapLink.set(positionMap);
    }
    if (data.appIcon !== undefined) {
      let appIconMap: Map<string, image.PixelMap> = this.appIconMapLink.get()
      appIconMap[data.sessionId] = data.appIcon;
      this.appIconMapLink.set(appIconMap);
    }
  }

  convertMediaInfoData(mediaInfoList: MediaInfoData[]) {
    let mediaInfoListOld = this.mediaInfoListDataLink.get();
    let mediaInfoListNew: MediaInfoListData[] = [];
    let infoIndex = 0;
    mediaInfoList.forEach((mediaInfo: MediaInfoData, index: number) => {
      let mediaInfoItem: MediaInfoListData;
      if (infoIndex > mediaInfoListOld.length - 1) {
        mediaInfoItem = new MediaInfoListData();
      } else {
        mediaInfoItem = mediaInfoListOld[index];
      }
      infoIndex++;
      mediaInfoItem.updateMediaInfoData(mediaInfo);
      mediaInfoListNew.push(mediaInfoItem);
    });
    this.mediaInfoListDataLink.set(mediaInfoListNew);
  }

  convertRecommendListData(avQueueInfo: AVQueueInfo[]) {
  }

  /**
   * sessionList变更
   */
  private syncSessionList = (data: SyncSessionListInfo) => {
    if (data.sessionList === undefined) {
      return;
    }
    if (data.sessionList.length === 0) {
      this.sessionListCache = ['default'];
      this.sessionListLink.set(['default']);
    } else {
      this.sessionListCache = data.sessionList;
      this.sessionListLink.set(data.sessionList);
    }
  }

  /**
   * 是否为投播session
   */
  private syncIsSinkSession = (data: SyncIsSinkSessionInfo) => {
    if (data.isSinkSession !== undefined) {
      DcMediaController.isSinkSession = data.isSinkSession;
    }
  }

  /**
   * 同步本地消息
   */
  private syncLocalNotify = (data: SyncLocalNotifyInfo) => {
    if (data.name === undefined || data.value === undefined) {
      return;
    }
    CommunicationUtil.doLocalEventNotify(data.name, data.value);
  }

  /**
   * 同步AppStorage
   */
  private syncAppStorage = (data: SyncAppStorageInfo) => {
    if (data.name === undefined) {
      return;
    }
    AppStorage.setOrCreate(data.name, data.value);
  }

  /**
   * 判断mediaImage是否需要释放
   * @param oldData
   * @param newData
   * @returns
   */
  checkUpdateImage(oldData: AVSessionManager.AVMetadata | undefined,
    newData: AVSessionManager.AVMetadata | undefined): boolean {
    // 媒体信息未发生变化，且原数据的mediaImage是pixelMap
    if (oldData?.assetId && oldData?.assetId === newData?.assetId && oldData?.mediaImage &&
      typeof oldData.mediaImage !== 'string') {
      return true;
    }
    return false;
  }

  /**
   * 释放PixelMap内存
   * @param data
   */
  clearPixelMapCache(data: AVSessionManager.AVMetadata) {
    if (!data) {
      return;
    }
    try {
      if (data.mediaImage && typeof data.mediaImage !== 'string') {
        (data.mediaImage as image.PixelMap).release();
      }
      if (data.avQueueImage && typeof data.avQueueImage !== 'string') {
        (data.avQueueImage as image.PixelMap).release();
      }
    } catch (err) {
      log.error(`clearPixelMapCache error, ${err}`);
    }
  }

  /**
   * session信息变更
   */
  private syncSessionData = (data: SyncSessionDataInfo) => {
    if (!data.sessionId) {
      return;
    }
    if (data.descriptor !== undefined) {
      this.avSessionDescriptorMap[data.sessionId] = data.descriptor;
    }
  }

  /**
   * 设备列表变更
   */
  private syncDeviceListData = (data: SyncDeviceListDataInfo) => {
    if (data.deviceList !== undefined) {
      this.mMergedDeviceListLink.set(data.deviceList);
    }
    if (data.callDeviceList !== undefined) {
      this.callDeviceListLink.set(data.callDeviceList);
    }
  }

  /**
   * 折叠屏数据更新
   */
  private syncMediaUpdate = (data: ShowingMesTS) => {
    CommunicationUtil.doLocalEventNotify('mediaUpdate', data);
  }

  /**
   * 设置主线程缓存
   * @param key
   * @param value
   */
  setAppStorage(key: string, value: boolean | string | Object | undefined) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'setAppStorage', storageKey: key, storageValue: value,
    });
  }
}