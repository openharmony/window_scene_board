/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import bundle from '@ohos.bundle';
import osAccount from '@ohos.account.osAccount';
import image from '@ohos.multimedia.image';
import AVSessionManager from '@ohos.multimedia.avsession';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import Constants, {
  AVQueueInfo,
  NewTime,
  ShowingBundleTS,
  SetVolumeType,
  InputVolumeAction,
  MediaInfoData,
  BundleStat
} from '../Util/Constants';
import { HiSysEvent, EventType, BizScene, BizState, StageResult, TriggerMode, SourceController,
  StartCAST } from '../Util/HiSysEvent';
import SessionInfoProvider from './SessionInfoProvider';
import VolumeManager from './VolumeManager';
import CommunicationUtil from '../Util/CommunicationUtil';
import { globalStorage } from '../Util/GlobalStorage';
import BusinessError from '@ohos.base';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { AVState, DfxParam, SessionController, VolumeInfo, RadarParam, PartialRadaParam,
  SongInfo } from '../Util/CommonInterface';
import bundleManager from '@ohos.bundle.bundleManager';
import { LocalEventCallback } from '../Util/LocalEventCallBack';
import { LocalDeviceInfo, WorkerMsgSubParameter } from '../Util/Constants';
import WantAgent, { WantAgent as _WantAgent} from '@ohos.app.ability.wantAgent';
import { combineObject } from '../Util/Tool';
import json from '@ohos.util.json';
import ImageDownloaderUtils from '../Util/ImageDownloaderUtils';
import CommonUtils from '../Util/CommonUtils';
import { CastDeviceControl } from './CastDeviceControl';
import avSession from '@ohos.multimedia.avsession';
import { MetadataChangeCallback, ValidCommandChangeCallback } from '../EventBus/MediaEventCallback';
import { MetadataChangeEvent, ValidCommandChangeEvent } from '../EventBus/MediaEvent';
import { MediaEventManager, MediaEventType } from '../EventBus/MediaEventManager';
import util from '@ohos.util';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ObjectCopyUtil } from '@ohos/componenthelper/src/main/ets/utils/ObjectCopyUtil';
import { MediaInfoListData } from '../viewmodel/MediaInfoListData';

const TAG = 'MediaInfoProvider_debug';
const radarBunldName = 'ohos.mediacontroller';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const TITLE_RESOURCE_KEY = 'titleResource';
const IS_SHOW_MORE_KEY = 'showMoreState';
const LOCAL: string = 'local';

export default class MediaInfoProvider {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private sessionListLink: AbstractProperty<Array<string>>;
  private metaDataMapLink: AbstractProperty<Map<string, AVSessionManager.AVMetadata>>;
  private imageRatioMapLink: AbstractProperty<Map<string, number>>; // 封面图比例
  private lastTitleMapLink: Map<string, string> = new Map();
  private appIconMapLink: AbstractProperty<Map<string, image.PixelMap>>;
  private playStateMapLink: AbstractProperty<Map<string, AVSessionManager.AVPlaybackState>>;
  private initDoneLink: AbstractProperty<boolean>;
  private commandEnableMapLink: AbstractProperty<Map<string, Array<AVSessionManager.AVControlCommandType>>>;
  private playbackPositionMapLink: AbstractProperty<Map<string, Object>>;
  private mediaInfoListDataLink: AbstractProperty<Array<MediaInfoListData>>;
  private isExistAvQueueInfoLink: AbstractProperty<Boolean>;
  private context: common.UIExtensionContext | common.ServiceExtensionContext | undefined;
  private preOrNextOperateTimeStamp: number = new Date().getTime();
  private sessionProvider: SessionInfoProvider | undefined = undefined;
  private static providerSelf: MediaInfoProvider | undefined = undefined;
  private commonInterface: CommonInterface | undefined = new CommonInterface();
  private volumeManager: VolumeManager | undefined = VolumeManager.getInstance(this.commonInterface);
  private isNeedPlayInActive: boolean = false;
  private moduleName: string = '';
  private appNameMapLink: AbstractProperty<Map<string, string>>;
  private albumInfoListLink: AbstractProperty<Array<AVQueueInfo>>;
  private cachedProcessingDfxParam: DfxParam | undefined = {};
  private appIconMap: Map<string, image.PixelMap> = new Map();
  private sessionChangedCallback: LocalEventCallback | undefined = undefined;
  private controllerChangedCallback: LocalEventCallback | undefined = undefined;
  private topSessionChangedCallback: LocalEventCallback | undefined = undefined;
  private sessionDestroyCallback: LocalEventCallback | undefined = undefined;
  private serviceDieCallback: LocalEventCallback | undefined = undefined;
  // 打点
  private pInfoName = globalStorage.getStringByKey('packageName');
  private pInfoVersion = globalStorage.getStringByKey('packageVersion');
  private isStartCastLink: AbstractProperty<boolean>;
  private seekFlag: boolean = false; // 投播seek标记
  private controlEventMap: Map<EventType, boolean> = new Map();
  private controlEventStartTime: Map<EventType, number> = new Map();
  private controlEventExtras: Map<EventType, DfxParam> = new Map();
  private controlEventTimeId: Map<EventType, number | undefined> = new Map();
  private controlEventSeekTime: Map<EventType, number> = new Map();
  private coldStartPlayback: Boolean = false;
  private coldStartMetadata: Boolean = false;
  private deviceFilter: avSession.ProtocolType | undefined = AppStorage.get('deviceFilter');
  private castSessionController: AVSessionManager.AVSessionController | undefined = undefined;
  public inputMediaVolumeCallback: (callback: inputConsumer.KeyOptions) => void = () => {};
  public inputCallVolumeCallback: (callback: inputConsumer.KeyOptions) => void = () => {};
  private mediaInfoList: MediaInfoData[] = [];  // 歌单数据
  private mediaInfoListRecommend: MediaInfoData[] = [];  // 歌单数据

  private constructor() {
    let tempMetaDataMap: Map<string, AVSessionManager.AVMetadata> = new Map();
    let tempImageRatioMap: Map<string, number> = new Map();
    let tempAppIconMap: Map<string, image.PixelMap> = new Map();
    let tempPlayStateMap: Map<string, AVSessionManager.AVPlaybackState> = new Map();
    let tempCommandEnableMap: Map<string, Array<AVSessionManager.AVControlCommandType>> = new Map();
    let tempPlaybackPositionMap: Map<string, Object> = new Map();
    let appNameMap: Map<string, string> = new Map();
    this.sessionListLink = AppStorage.setAndRef('sessionList', []);
    this.metaDataMapLink = AppStorage.setAndRef('MetaDataMap', tempMetaDataMap);
    this.imageRatioMapLink = AppStorage.setAndRef('imageRatioMap', tempImageRatioMap);
    this.appIconMapLink = AppStorage.setAndRef('appIconMap', tempAppIconMap);
    this.playStateMapLink = AppStorage.setAndRef('PlayStateMap', tempPlayStateMap);
    this.initDoneLink = AppStorage.setAndRef('InitDone', false);
    this.isStartCastLink = AppStorage.setAndRef('isStartCast', false);
    this.commandEnableMapLink = AppStorage.setAndRef('commandEnableMap', tempCommandEnableMap);
    this.playbackPositionMapLink = AppStorage.setAndRef('playbackPositionMap', tempPlaybackPositionMap);
    this.mediaInfoListDataLink = AppStorage.setAndRef('mediaInfoListData', []);
    this.isExistAvQueueInfoLink = AppStorage.setAndRef('isExistAvQueueInfo', false);
    this.context = GlobalContext.getContext();
    this.appNameMapLink = AppStorage.setAndRef('appNameMap', appNameMap);
    this.albumInfoListLink = AppStorage.setAndRef('AlbumInfoList', []);
  }

  public static getInstance() : MediaInfoProvider {
    log.showInfo(`media provider getInstance, already init =  ${!!MediaInfoProvider.providerSelf}`);
    if (!MediaInfoProvider.providerSelf) {
      MediaInfoProvider.providerSelf = new MediaInfoProvider();
      MediaInfoProvider.providerSelf.init();
      MediaInfoProvider.providerSelf.initWorker();
    }
    return MediaInfoProvider.providerSelf;
  }

  async init() {
    log.showInfo('init start')
    this.setAVSessionCreateListener();
    this.registerControllerChanged();
    this.registerTopSessionChangeHis();
    await this.getMetadataFromAVSession();
  }

  /**
   * 子线程初始化
   */
  initWorker() {
    if (!this.enableDc) {
      return;
    }
    log.showInfo(`init worker: ${TAG}`);
    messageChannel.registerCallObject(Constants.MEDIA_INFO_PROVIDER, MediaInfoProvider.providerSelf);
    messageChannel.onMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, this.callByWorker); // 监听子线程消息
  }

  /**
   * 子线程调用方法，统一处理异步函数
   */
  private callByWorker = (parameter: WorkerMsgSubParameter) => {
    if (parameter.type !== undefined) {
      this.callOperation[parameter.type]?.(parameter);
    }
  }

  /**
   * 响应子线程操作回调，使用字面量对象优化switch case
   */
  private callOperation: Record<string, (parameter: WorkerMsgSubParameter) => void> = {
    'getMetadataFromAVSession': (parameter: WorkerMsgSubParameter) => {
      this.getMetadataFromAVSession();
    },
    'rewind': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.movePosition !== undefined) {
        this.callRewind(parameter.sessionId, parameter.movePosition);
      }
    },
    'fastForward': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.movePosition !== undefined) {
        this.callForward(parameter.sessionId, parameter.movePosition);
      }
    },
    'favor': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.isFavorite !== undefined) {
        this.callFavorites(parameter.sessionId, parameter.isFavorite);
      }
    },
    'previous': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined) {
        this.callPrevious(parameter.sessionId);
      }
    },
    'next': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined) {
        this.callNext(parameter.sessionId);
      }
    },
    'play': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.isColdStart !== undefined) {
        this.callPlay(parameter.sessionId, parameter?.isColdStart, parameter?.isForceTopSession);
      }
    },
    'pause': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined) {
        this.callPause(parameter.sessionId);
      }
    },
    'startDefaultAppNow': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.isFromSessionCreate !== undefined &&
        parameter?.shouldCallPlay !== undefined) {
        this.startDefaultAppNow(parameter.sessionId, parameter.isFromSessionCreate, parameter.shouldCallPlay);
      }
    },
    'startAimApp': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined) {
        this.startAimApp(parameter.sessionId);
      }
    },
    'seek': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.time !== undefined) {
        this.callSeek(parameter.sessionId, parameter.time);
      }
    },
    'loopMode': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.loopMode !== undefined) {
        this.callLoop(parameter.sessionId, parameter.loopMode);
      }
    },
    'callVolumeChange': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.volume !== undefined && parameter?.mode !== undefined) {
        this.callVolumeChange(parameter.volume, parameter.mode, parameter?.sessionId);
      }
    },
    'callVolumeInput': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.volumeType !== undefined && parameter?.actionType !== undefined) {
        this.callVolumeInput(parameter.volumeType, parameter.actionType, parameter?.sessionId);
      }
    },
    'startAlbum': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.avQueueId !== undefined) {
        let albumInfoList: AVQueueInfo[] = this.albumInfoListLink.get();
        let albInfo: AVQueueInfo = albumInfoList.find((item: AVQueueInfo) => {
          return !!item.avQueueId && item.avQueueId === parameter.avQueueId;
        }) || {};
        this.startAlbum(albInfo, albumInfoList);
      }
    },
    'startExpandAlbum': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.avQueueId !== undefined) {
        let albumInfoList: AVQueueInfo[] = this.albumInfoListLink.get();
        let albInfo: AVQueueInfo = albumInfoList.find((item: AVQueueInfo) => {
          return !!item.avQueueId && item.avQueueId === parameter.avQueueId;
        }) || {};
        this.startExpandAlbum(albInfo, albumInfoList);
      }
    },
    'reportStartMediaPlayBack': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.avQueueId !== undefined && parameter?.timeCost !== undefined) {
        let albumInfoList: AVQueueInfo[] = this.albumInfoListLink.get();
        let albInfo: AVQueueInfo = albumInfoList.find((item: AVQueueInfo) => {
          return !!item.avQueueId && item.avQueueId === parameter.avQueueId;
        }) || {};
        this.reportStartMediaPlayBack(albInfo, parameter.timeCost);
      }
    },
    'initShowRecommend': (parameter: WorkerMsgSubParameter) => {

    },
    'getHistoricalOrRecommendData': (parameter: WorkerMsgSubParameter) => {
    },
    'getHistoricalAndRecommendData': (parameter: WorkerMsgSubParameter) => {
      this.getHistoricalAndRecommendData();
    },
    'getHistoryFromAVSession': (parameter: WorkerMsgSubParameter) => {
      this.getHistoryFromAVSession();
    },
    'setCastSessionListener': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.hasCast !== undefined) {
        this.setCastSessionListener(parameter?.hasCast, parameter?.sessionId);
      }
    },
    'clearCastSessionListener': (parameter: WorkerMsgSubParameter) => {
      this.clearCastSessionListener();
    },
    'reportShowDeviceList': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.startTime !== undefined &&
        parameter?.isShowSwitch !== undefined) {
        this.reportShowDeviceList(parameter?.sessionId, parameter?.startTime, parameter?.isShowSwitch);
      }
    },
    'deleteAlbumInfoListLink': (parameter: WorkerMsgSubParameter) => {
      this.deleteAlbumInfoListLink();
    },
    'refreshVolume': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined) {
        this.refreshVolume(parameter?.sessionId);
      }
    },
    'callCastVolumeChange': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.actionType !== undefined) {
        this.callCastVolumeChange(parameter?.sessionId, parameter?.actionType);
      }
    },
    'replayAlbum':  (parameter: WorkerMsgSubParameter) => {
      if (parameter?.avQueueId !== undefined && parameter?.oldAvQueueId !== undefined) {
        let albumInfoList: AVQueueInfo[] = this.albumInfoListLink.get();
        let albInfo: AVQueueInfo = albumInfoList.find((item: AVQueueInfo) => {
          return !!item.avQueueId && item.avQueueId === parameter.avQueueId;
        }) || {};
        let oldAlbInfo: AVQueueInfo = albumInfoList.find((item: AVQueueInfo) => {
          return !!item.avQueueId && item.avQueueId === parameter.oldAvQueueId;
        }) || {};
        this.replayAlbum(albInfo, oldAlbInfo);
      }
    },
    'playAvQueue': (parameter: WorkerMsgSubParameter) => {
      this.playAvQueue(parameter.bundleName || '', parameter.avQueueId || '');
    },
    'reportAVQueueShowState': (parameter: WorkerMsgSubParameter) => {
      if (parameter?.showState !== undefined && parameter?.operatingMode !== undefined &&
        parameter?.isHistoryAVQueue !== undefined) {
        this.reportAVQueueShowState(parameter?.showState, parameter?.operatingMode, parameter?.isHistoryAVQueue);
      }
    },
    'isExistAvQueueStateUpdate': (parameter: WorkerMsgSubParameter) => {
      this.isExistAvQueueStateUpdate();
    },
    'releaseInputMediaVolumeCallback': (parameter: WorkerMsgSubParameter) => {
      this.releaseInputMediaVolumeCallback();
    },
  }

  getSessionChangedCallback(): LocalEventCallback {
    if (!this.sessionChangedCallback) {
      this.sessionChangedCallback = new LocalEventCallback((sessionId: string) => {
        log.showInfo(`session create event: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
          sessionId?.substr(sessionId?.length - 5))}`);
        this.startDefaultAppNow(sessionId, true, false);
      });
    }
    return this.sessionChangedCallback;
  }

  getControllerChangedCallback(): LocalEventCallback {
    if (!this.controllerChangedCallback) {
      this.controllerChangedCallback = new LocalEventCallback(async (sessionId: string) => {
        log.showInfo('on controller changed, refresh media info');
        const sessionController = this.sessionProvider?.avSessionControllerMap.get(sessionId);
        if (sessionController) {
          this.setAVSessionContentListener(sessionController);
          this.refreshPlayState(sessionController);
          this.refreshMetaData(sessionController);
          this.refreshFavoriteEnable(sessionController.sessionId, sessionController);
          this.refreshVolume(sessionId);
        }
      });
    }
    return this.controllerChangedCallback;
  }

  getTopSessionChangedCallback(): LocalEventCallback {
    if (!this.topSessionChangedCallback) {
      this.topSessionChangedCallback = new LocalEventCallback(async (sessionId: string) => {
        log.showInfo(`top session Change event: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
          sessionId?.substr(sessionId?.length - 5))}`);
        await this.sessionProvider?.doSessionCollection();
        const sessionController = this.sessionProvider?.avSessionControllerMap.get(sessionId);
        if (sessionController) {
          await this.refreshMetaData(sessionController);
          await this.refreshPlayState(sessionController);
          await this.refreshFavoriteEnable(sessionController.sessionId, sessionController);
        }
        this.refreshHistoricalAndRecommendData();
      });
    }
    return this.topSessionChangedCallback;
  }

  getSessionDestroyCallback(): LocalEventCallback {
    log.showInfo(`getSessionDestroyCallback`)
    if (!this.sessionDestroyCallback) {
      this.sessionDestroyCallback = new LocalEventCallback(async (sessionId: string) => {
        log.showInfo(`session destroy: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
          sessionId?.substr(sessionId?.length - 5))}`);
        let metaDataMap = this.metaDataMapLink.get();
        // 释放PixelMap内存
        this.clearPixelMapCache(metaDataMap[sessionId]);
        metaDataMap[sessionId] = undefined;
        this.metaDataMapLink.set(metaDataMap);
        let imageRatioMap = this.imageRatioMapLink.get();
        imageRatioMap[sessionId] = undefined;
        this.imageRatioMapLink.set(imageRatioMap);
        let lastTitleMap = this.lastTitleMapLink;
        lastTitleMap[sessionId] = undefined;
        this.lastTitleMapLink = lastTitleMap;
        let playStateMap = this.playStateMapLink.get();
        playStateMap[sessionId] = undefined;
        this.playStateMapLink.set(playStateMap);
        let commandEnableMap = this.commandEnableMapLink.get();
        commandEnableMap[sessionId] = undefined;
        this.commandEnableMapLink.set(commandEnableMap);
        if (this.enableDc) {
          // 通知子线程
          messageChannel.sendMessage('syncSubData', { sessionId, needRemove: true });
          messageChannel.sendMessage('syncAppStorage', { name: 'isCasting', value: false });
        }
        this.commonInterface?.releaseCallbackBySession(sessionId);
        if (!this.sessionProvider || !this.sessionProvider.avSessionControllerMap.size) {
          log.error(`on sessionDestroy without sessionProvider return`);
          return;
        }
        this.sessionProvider.bundleNameMap[sessionId] = '';
        this.sessionProvider.abilityNameMap[sessionId] = '';
        this.sessionProvider.avSessionDescriptorMap.delete(sessionId);
        this.sessionProvider.avSessionControllerMap.delete(sessionId);
        this.refreshHistoricalAndRecommendData();
        log.showInfo(' sessionDestroy callback state done');
      });
    }
    return this.sessionDestroyCallback;
  }

  getServiceDieCallback(): LocalEventCallback {
    if (!this.serviceDieCallback) {
      this.serviceDieCallback = new LocalEventCallback(async (message: string) => {
        this.commonInterface?.releaseCallback();
      });
    }
    return this.serviceDieCallback;
  }

  /**
   * 设置监听
   */
  async setAVSessionCreateListener() {
    log.showInfo('sessionCreateListener set');
    SessionInfoProvider.on('sessionChanged', this.getSessionChangedCallback());
    SessionInfoProvider.on('sessionDestroy', this.getSessionDestroyCallback());
    SessionInfoProvider.on('sessionServiceDie', this.getServiceDieCallback());
  }

  /**
   * 获取媒体信息
   */
  async getMetadataFromAVSession() {
    log.showInfo('Start get metadata');
    this.sessionProvider = await SessionInfoProvider.getInstance();
    if (!this.sessionProvider) {
      log.warn(' getMetadataFromAVSession find no sessionProvider error');
      return;
    }
    if (this.commonInterface) {
      this.commonInterface.init(this.sessionProvider, this.volumeManager);
    }
    let sessionList: string[] = this.sessionListLink.get();
    for (let i = 0; i < sessionList.length; i++) {
      let sessionId: string = sessionList[i];
      let sessionDescriptor: AVSessionManager.AVSessionDescriptor =
        this.sessionProvider?.avSessionDescriptorMap[sessionId];
      this.refreshAppIcon(sessionId);
      if (!sessionDescriptor) {
        log.warn('sessionDescriptor find null , continue');
        continue;
      }
      let sessionController = this.sessionProvider?.avSessionControllerMap.get(sessionId);
      if (sessionController) {
        await this.refreshMediaInfo(sessionController);
      } else {
        log.error('sessionController null')
      }
    }
    log.showInfo('Get metadata end:' + sessionList.length);
  }

  getHistoryFromAVSession() {

  }

  private registerControllerChanged(): void {
    SessionInfoProvider.on('controllerChanged', this.getControllerChangedCallback());
  }

  private registerTopSessionChangeHis(): void {
    SessionInfoProvider.on('topSessionChangeHis', this.getTopSessionChangedCallback());
  }

  async reportGetHistoricalAVQueueInfos() {
    let avQueueInfoList: AVQueueInfo[] = await AVSessionManager.getHistoricalAVQueueInfos(5, 5);
    log.showInfo(' report HISTORY_AVQUEUE_INFO:' + JSON.stringify(avQueueInfoList));
    let startTime = new Date().getTime();
    avQueueInfoList.forEach((avQueueInfo: AVQueueInfo) => {
      let dfxParam : DfxParam = {
        PNAMEID: this.pInfoName,
        PVERSIONID: this.pInfoVersion,
        PACKAGE_NAME : avQueueInfo.bundleName,
        AVQUEUE_NAME : avQueueInfo.avQueueName,
        AVQUEUE_ID: avQueueInfo.avQueueId,
        TIME: startTime,
        SCREENSTATUS: this.getScreenStatus(),
        DEVICEMODELTYPE: this.getDeviceModelType(),
        SCREENFOLDEDSTATUS: this.getFold()
      };
      HiSysEvent.getEventParam(EventType.HISTORY_AVQUEUE_INFO)
        .updateAllExtendParam(dfxParam)
        .reportEvent(true);
    });
    this.releaseAlbumListPixelmap(avQueueInfoList);
  }

  reportStartMediaPlayBack(info : AVQueueInfo, timeCost : number) : void {
    let startTime = new Date().getTime();
    let dfxParam : DfxParam = {
      PNAMEID: this.pInfoName,
      PVERSIONID: this.pInfoVersion,
      PACKAGE_NAME: info.bundleName,
      AVQUEUE_NAME: info.avQueueName,
      AVQUEUE_ID: info.avQueueId,
      TIME_COST: timeCost,
      TIME: startTime,
      SCREENSTATUS: this.getScreenStatus(),
      DEVICEMODELTYPE: this.getDeviceModelType(),
      SCREENFOLDEDSTATUS: this.getFold()
    };
    log.showInfo(' report HISTORY_AVQUEUE_PLAY:' + JSON.stringify(dfxParam));
    HiSysEvent.getEventParam(EventType.HISTORY_AVQUEUE_PLAY)
      .updateAllExtendParam(dfxParam)
      .reportEvent(true);
  }

  async refreshMediaInfo(controller: AVSessionManager.AVSessionController) {
    log.showInfo(`refresh media info for: ${controller.sessionId?.length < 10 ? '' :
      (controller.sessionId?.substr(0, 5) + '**' + controller.sessionId?.substr(controller.sessionId?.length - 5))}`);
    await this.setAVSessionContentListener(controller);
    await this.refreshMetaData(controller);
    await this.refreshPlayState(controller);
    await this.refreshFavoriteEnable(controller.sessionId, controller);
    log.showInfo(`collect info done for session: ${controller.sessionId?.length < 10 ? '' :
      (controller.sessionId?.substr(0, 5) + '**' + controller.sessionId?.substr(controller.sessionId?.length - 5))}`);
  }


  async downloadImage(image: string, sessionId: string): Promise<string> {
    let curImage: string = '';
    curImage = await ImageDownloaderUtils.downloadImage(image);
    await this.ConvertImageFormat(curImage, sessionId);
    log.showInfo(`downloadImage success done`)
    return curImage;
  }

  async ConvertImageFormat(mediaImage: string, sessionId:string) {
    try {
      log.showInfo(`ConvertImageFormat start`);
      const reg = new RegExp('data:image\/png;base64,');
      const base64Str = mediaImage.replace(reg, '');
      let helper = new util.Base64Helper();
      let buffer: ArrayBuffer = helper.decodeSync(base64Str).buffer as ArrayBuffer;
      let imageSource = image.createImageSource(buffer);
      let opts: image.DecodingOptions = { editable: true };
      let pixelMap = await imageSource.createPixelMap(opts);
      await this.getPixelImageInfo(pixelMap, sessionId);
      imageSource.release();
      pixelMap.release();
      log.showInfo(`ConvertImageFormat done`);
    } catch (err) {
      log.error(`fail to convertImageFormat: ${JSON.stringify(err)}`)
    }
  }

  async getPixelImageInfo(pixImage: image.PixelMap, sessionId: string) {
    try {
      let info: image.ImageInfo = await pixImage.getImageInfo();
      let imageRatioMap = this.imageRatioMapLink.get();
      imageRatioMap[sessionId] = info.size.width / info.size.height;
      this.imageRatioMapLink.set(imageRatioMap);
      if (this.enableDc) {
        // 通知子线程
        messageChannel.sendMessage('syncSubData', { sessionId, imageRatio: imageRatioMap[sessionId] });
      }
      log.showInfo(`get image infosize width: ${info.size.width} height: ${info.size.height}`);
    } catch (err) {
      log.error('Failed to obtain the image pixel map information.And the error is: ', err);
    }
  }

  async refreshMetaData(controller: AVSessionManager.AVSessionController) {
    let avMetadata: AVSessionManager.AVMetadata | undefined =
      await this.commonInterface?.getAVMetadata(controller.sessionId);
    if (!avMetadata) {
      log.warn(`refreshMetaData avMetadata is null`);
      return;
    }
    log.showInfo(`get session metadata: ${JSON.stringify(avMetadata)}`);
    if (typeof avMetadata.mediaImage !== 'string' && avMetadata.mediaImage) {
      log.showInfo('get session metadata, pixel image size : ' + avMetadata.mediaImage.getPixelBytesNumber());
    }
    if (typeof avMetadata.mediaImage === 'string' && avMetadata.mediaImage && avMetadata.mediaImage.startsWith('http')) {
      avMetadata!.mediaImage = await this.downloadImage(avMetadata.mediaImage as string, controller.sessionId);
      log.showInfo('Metadata change image fresh with string type ');
    } else if (avMetadata.mediaImage && typeof avMetadata.mediaImage !== 'string') {
      await this.getPixelImageInfo(avMetadata.mediaImage, controller.sessionId);
    } else if (typeof avMetadata.mediaImage === 'string' && !CommonUtils.isBase64Image(avMetadata.mediaImage)) {
      avMetadata.mediaImage = undefined;
      log.showInfo(`Metadata change image undefined`);
    } else {
      log.showInfo(`Metadata change image fresh with other type`);
    }

    let lastTitleMap = this.lastTitleMapLink;
    lastTitleMap[controller.sessionId] = avMetadata.title;
    this.lastTitleMapLink = lastTitleMap;
    let bundleName: string = this.sessionProvider?.bundleNameMap[controller.sessionId];
    let songInfo: SongInfo | undefined;
    if (bundleName === 'com.ohos.music' && avMetadata.description) {
      songInfo = this.getSongInfo(avMetadata.description);
    }
    if (avMetadata.lyric && songInfo && songInfo.songName && songInfo.songArtist) {
      avMetadata.title = songInfo.songName + '-' + songInfo.songArtist;
    } else if (avMetadata.lyric && avMetadata.title !== undefined &&
      (avMetadata.artist !== undefined || avMetadata.subtitle !== undefined)) {
      avMetadata.title = avMetadata.title + '-' + (avMetadata.artist || avMetadata.subtitle);
    }
    let tempMetaDataMap = this.metaDataMapLink.get();
    if (!this.checkUpdateImage(tempMetaDataMap[controller.sessionId], avMetadata)) {
      // 释放PixelMap内存
      this.clearPixelMapCache(tempMetaDataMap[controller.sessionId]);
    }
    tempMetaDataMap[controller.sessionId] = avMetadata;
    this.metaDataMapLink.set(tempMetaDataMap);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { sessionId: controller.sessionId, metadata: avMetadata });
    }
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

  async refreshAppIcon(sessionId: string) {
    log.showInfo(`try refreshAppIcon from bundle: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    if (!this.sessionProvider?.bundleNameMap[sessionId]) {
      log.showInfo(' refreshAppIcon from bundle fail: elementName undefined');
      return;
    }
    log.showInfo(`get session descriptor app config getBundleInfo: ${sessionId?.length < 10 ? '' :
      (sessionId?.substr(0, 5) + '**' + sessionId?.substr(sessionId?.length - 5))},
      ${this.sessionProvider?.bundleNameMap[sessionId]}`);

    // source icon
    this.moduleName = '';
    try {
      log.showInfo(`get app icon in another way for : ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
        sessionId?.substr(sessionId?.length - 5))}`);
      const mediaAppPixelMap = await this.getBundleInfo(this.sessionProvider?.bundleNameMap[sessionId],
        this.sessionProvider?.abilityNameMap[sessionId]);
      if (mediaAppPixelMap) {
        let tempAppIconMap: Map<string, image.PixelMap> = this.appIconMapLink.get();
        tempAppIconMap[sessionId] = mediaAppPixelMap;
        this.appIconMapLink.set(tempAppIconMap);
        if (this.enableDc) {
          // 通知子线程
          messageChannel.sendMessage('syncSubData', { sessionId, appIcon: mediaAppPixelMap });
        }
      }
    } catch (err) {
      log.showInfo(`get source icon by elementName err: ${err}`);
    }
    log.showInfo('set app icon done');
    // app name
    log.showInfo('try refresh app name');
    let sessionController = this.sessionProvider?.avSessionControllerMap.get(sessionId);
    let appName: string = '';
    if (sessionController) {
      let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
      let moduleName: string = this.moduleName;
      let abilityName: string = this.sessionProvider?.abilityNameMap[sessionId];
      log.showInfo(`getAppName: ${JSON.stringify(bundleName)}, ${JSON.stringify(moduleName)},
      ${JSON.stringify(abilityName)}`);
      try {
        appName = await bundleManager.getAbilityLabel(bundleName, moduleName, abilityName);
        log.showInfo(`getAbilityLabel res: ${appName}`);
      } catch (err) {
        log.showInfo(`getAbilityLabel failed: ${JSON.stringify(err)}`);
      }
    }
    let tempAppName: Map<string, string> = this.appNameMapLink.get();
    tempAppName[sessionId] = appName;
    this.appNameMapLink.set(tempAppName);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { sessionId, appName });
    }
    log.showInfo('refresh app name done: ' + appName);
  }

  async getAVQueueIcon(bundleName?: string) : Promise<PixelMap | undefined> {
    if (!bundleName) {
      return undefined;
    }
    // source icon
    try {
      log.showInfo(`getAVQueueIcon in another way for : ${bundleName}`);
      let pixelMap: ShowingBundleTS | undefined = await this.sessionProvider?.getIconWithOnlyBundle(bundleName);
      return pixelMap?.pixelData;
    } catch (err) {
      log.showInfo(`getAVQueueIcon by BundleInfo err: ${err}`);
    }
    return undefined;
  }

  async getAppName(bundleName?: string): Promise<string | undefined> {
    if (!bundleName) {
      return undefined;
    }
    try {
      log.showInfo(`getAppName in another way for : ${bundleName}`);
      let bundleTs: ShowingBundleTS | undefined = await this.sessionProvider?.getIconWithOnlyBundle(bundleName);
      return bundleTs?.appName;
    } catch (err) {
      log.showInfo(`getAppName by BundleInfo err: ${err}`);
    }
    return undefined;
  }

  deleteAlbumInfoListLink() {
    let albumInfoList: AVQueueInfo[] = this.albumInfoListLink.get();
    this.releaseAlbumListPixelmap(albumInfoList);
    this.albumInfoListLink.set([]);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { albumInfoList: [] });
    }
    this.mediaInfoListDataLink.set([]);
  }

  releaseAlbumListPixelmap(albumInfoList: AVQueueInfo[]) {
    for (let info of albumInfoList) {
      let picToRelease = info.avQueueImage;
      if (!!picToRelease && typeof picToRelease === 'object') {
        (picToRelease as image.PixelMap).release();
      }
    }
  }

  public async getHistoricalData() {
    try {
      log.showInfo(`get historicalAlbums.`);
      let aqtempList: AVQueueInfo[] = [];
      let historicalAlbums = await AVSessionManager.getHistoricalAVQueueInfos(5, 5);
      if (!historicalAlbums || historicalAlbums.length <= 0) {
        this.albumInfoListLink.set([]);
        if (this.enableDc) {
          // 通知子线程
          messageChannel.sendMessage('syncSubData', { albumInfoList: [] });
        }
        return
      }
      log.showInfo(`hisAVQueue getHistoricalAVQueueInfos:` + JSON.stringify(historicalAlbums));
      let maxLength = historicalAlbums.length <= 8 ? historicalAlbums.length : 8;
      for (let i = 0; i < maxLength; i++) {
        let appIcon: image.PixelMap | undefined = this.appIconMap.get(historicalAlbums[i].bundleName) || undefined;
        if (!appIcon) {
          appIcon = await this.getAVQueueIcon(historicalAlbums[i].bundleName);
        }
        if (appIcon) {
          this.appIconMap.set(historicalAlbums[i].bundleName, appIcon);
          let avQueueInfo: AVQueueInfo = {
            bundleName: historicalAlbums[i].bundleName,
            avQueueName: historicalAlbums[i].avQueueName,
            avQueueId: historicalAlbums[i].avQueueId,
            avQueueImage: historicalAlbums[i].avQueueImage,
            lastPlayedTime: historicalAlbums[i].lastPlayedTime,
            appIconImage: appIcon
          }
          if (typeof avQueueInfo.avQueueImage == 'string') {
            log.showInfo(`getHistoricalData downloadImage: skip`);
            avQueueInfo.avQueueImage = '';
          }
          aqtempList.push(avQueueInfo);
          if (aqtempList.length == maxLength) {
            log.showInfo(`hisAVQueue getHistoricalAVQueueInfos load appIcon : ${aqtempList.length}`);
            AppStorage.setOrCreate(TITLE_RESOURCE_KEY, $r('app.string.RecentlyPlay'));
            let albumInfoList: AVQueueInfo[] = this.albumInfoListLink.get();
            this.releaseAlbumListPixelmap(albumInfoList);
            this.albumInfoListLink.set(aqtempList);
            if (this.enableDc) {
              // 通知子线程
              messageChannel.sendMessage('syncSubData', { albumInfoList: aqtempList });
              messageChannel.sendMessage('syncAppStorage', {
                name: TITLE_RESOURCE_KEY, value: $r('app.string.RecentlyPlay')
              });
            }
          }
        }
      }
    } catch (err) {
      // 获取历史出错，则不展示下方容器
      log.showInfo(`hisAVQueue fail to get historicalAVQueueInfo: ${JSON.stringify(err)}`);
    }
  }

  private async getActiveAppMetaData(isFromRecommend: boolean) {
    // 活跃的应用
    let descriptors: AVSessionManager.AVSessionDescriptor[] = await AVSessionManager.getAllSessionDescriptors();
    // 正在播放的应用
    let playingDescriptors: AVSessionManager.AVSessionDescriptor[] = [];
    // 有媒体信息未在播放的应用
    let metaDataDescriptors: AVSessionManager.AVSessionDescriptor[] = [];
    for (let descriptor of descriptors) {
      let sessionId = descriptor.sessionId;
      let playState = (await this.commonInterface?.getAVPlaybackState(sessionId))?.value;
      if (playState && (playState.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
        playState.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING)) {
        playingDescriptors.push(descriptor);
      } else {
        metaDataDescriptors.push(descriptor);
      }
    }

    await this.getActiveAndPlayingAppMetaData(playingDescriptors, isFromRecommend);

    await this.getActiveAndNotPlayingAppMetaData(metaDataDescriptors, isFromRecommend);
  }

  async getActiveAndPlayingAppMetaData(playingDescriptors: AVSessionManager.AVSessionDescriptor[],
    isFromRecommend: boolean) {
    // 遍历正在播放的应用
    for (let index = 0; index < playingDescriptors.length; index++) {
      let descriptor = playingDescriptors[index];
      let sessionId = descriptor.sessionId;
      let metaData = await this.commonInterface?.getAVMetadata(sessionId);
      let mediaInfo = this.getMediaInfoList(isFromRecommend).find((mediaInfo: MediaInfoData) => {
        return mediaInfo.bundleName === descriptor.elementName.bundleName;
      });
      if (!mediaInfo && metaData && metaData.title && metaData.artist) {
        let mediaInfoData: MediaInfoData = {
          sessionId: sessionId,
          isPlaying: true,
          title: metaData.title || '',
          author: metaData.artist || '',
          album: metaData.mediaImage || '',
          appIcon: await this.getAVQueueIcon(descriptor.elementName.bundleName) || '',
          hasMedia: true,
          isAVQueue: false,
          avQueueId: metaData.avQueueId || '',
          bundleName: descriptor.elementName.bundleName
        }
        log.showInfo(`getActiveAndPlayingAppMetaData: ${metaData.title}`)
        this.getMediaInfoList(isFromRecommend).push(mediaInfoData);
      }
    }
  }


  async getActiveAndNotPlayingAppMetaData(metaDataDescriptors: AVSessionManager.AVSessionDescriptor[],
    isFromRecommend: boolean) {
    // 遍历有媒体信息未在播放的应用
    for (let index = 0; index < metaDataDescriptors.length; index++) {
      let descriptor = metaDataDescriptors[index];
      let sessionId = descriptor.sessionId;
      let metaData = await this.commonInterface?.getAVMetadata(sessionId);
      let mediaInfo = this.getMediaInfoList(isFromRecommend).find((mediaInfo: MediaInfoData) => {
        return mediaInfo.bundleName === descriptor.elementName.bundleName;
      });
      if (!mediaInfo && metaData && metaData.title && metaData.artist) {
        let mediaInfoData: MediaInfoData = {
          sessionId: sessionId,
          isPlaying: false,
          title: metaData.title || '',
          author: metaData.artist || '',
          album: metaData.mediaImage || '',
          appIcon: await this.getAVQueueIcon(descriptor.elementName.bundleName) || '',
          hasMedia: true,
          isAVQueue: false,
          avQueueId: metaData.avQueueId || '',
          bundleName: descriptor.elementName.bundleName
        };
        log.showInfo(`getActiveAndNotPlayingAppMetaData: ${CommonUtils.getMaskStr(metaData.title)}`);
        this.getMediaInfoList(isFromRecommend).push(mediaInfoData);
      }
    }
  }

  private async getHistoryAvQueueInfo(isFromRecommend: boolean) {
    // 历史歌单
    let historicalAlbums: AVSessionManager.AVQueueInfo[] = await AVSessionManager.getHistoricalAVQueueInfos(5, 5);
    historicalAlbums = historicalAlbums.slice(0, 5);
    let historyDescriptors: AVSessionManager.AVSessionDescriptor[] =
      await AVSessionManager.getHistoricalSessionDescriptors();
    let activeDescriptors: AVSessionManager.AVSessionDescriptor[] =
      await AVSessionManager.getAllSessionDescriptors();
    for (let index = 0; index < historyDescriptors.length; index++) {
      let descriptor = historyDescriptors[index];
      // 找到歌单所在位置
      let beforeQueueInfo: AVSessionManager.AVQueueInfo[] = [];
      // 当前应用所在的位置
      let currentQueueInfo: AVSessionManager.AVQueueInfo | undefined = undefined;
      for (let queueIndex = 0; queueIndex < historicalAlbums.length; queueIndex++) {
        if (historicalAlbums[queueIndex].bundleName === descriptor.elementName.bundleName) {
          currentQueueInfo = historicalAlbums[queueIndex];
          break;
        } else {
          beforeQueueInfo.push(historicalAlbums[queueIndex]);
        }
      }
      if (!currentQueueInfo) {
        await this.getAppInfo(descriptor, isFromRecommend);
      } else {
        await this.getAvQueueBeforeCurrentIndex(beforeQueueInfo, historyDescriptors, activeDescriptors,
          isFromRecommend);
        await this.getAvQueueCurrentIndex(currentQueueInfo, descriptor, isFromRecommend);
      }
    }
    await this.getAvQueueOthers(historicalAlbums, historyDescriptors, activeDescriptors, isFromRecommend);
  }

  private async getAvQueueBeforeCurrentIndex(beforeQueueInfo: AVSessionManager.AVQueueInfo[],
    historyDescriptors: AVSessionManager.AVSessionDescriptor[],
    activeDescriptors: AVSessionManager.AVSessionDescriptor[], isFromRecommend: boolean) {
    if (beforeQueueInfo.length > 0) { // 处理当前应用歌单位置之前的歌单
      for (let beforeQueueIndex = 0; beforeQueueIndex < beforeQueueInfo.length; beforeQueueIndex++) {
        let queueInfo = beforeQueueInfo[beforeQueueIndex];
        let mediaInfo = this.getMediaInfoList(isFromRecommend).find((mediaInfo: MediaInfoData) => {
          return mediaInfo.avQueueId === queueInfo.avQueueId && mediaInfo.bundleName === queueInfo.bundleName;
        });
        // 同一个应用的歌单数量
        let mediaInfoCount =
          this.getMediaInfoList(isFromRecommend)
            .filter((mediaInfo: MediaInfoData) => mediaInfo.bundleName === queueInfo.bundleName);
        // 没找到则加入到列表中
        if (!mediaInfo && mediaInfoCount && mediaInfoCount.length < 2) {
          let descriptor = historyDescriptors.find((descriptorInfo: AVSessionManager.AVSessionDescriptor) =>
            descriptorInfo.elementName.bundleName === queueInfo.bundleName);
          if (descriptor === undefined) {
            descriptor = activeDescriptors.find((descriptorInfo: AVSessionManager.AVSessionDescriptor) =>
            descriptorInfo.elementName.bundleName === queueInfo.bundleName);
          }
          let mediaInfoData: MediaInfoData = {
            sessionId: descriptor?.sessionId || '',
            isPlaying: false,
            appIcon: await this.getAVQueueIcon(queueInfo.bundleName) || '',
            queueAlbum: queueInfo?.avQueueImage || '',
            queueName: queueInfo?.avQueueName || '',
            hasMedia: false,
            isAVQueue: true,
            avQueueId: queueInfo?.avQueueId || '',
            bundleName: queueInfo?.bundleName || ''
          };
          log.showInfo(`getAvQueueBeforeCurrentIndex avQueueName: ${queueInfo?.avQueueName}`);
          this.getMediaInfoList(isFromRecommend).push(mediaInfoData);
        }
      }
    }
  }

  private async getAvQueueCurrentIndex(currentQueueInfo: AVSessionManager.AVQueueInfo | undefined,
    descriptor: AVSessionManager.AVSessionDescriptor, isFromRecommend: boolean) {
    if (!currentQueueInfo) {
      return;
    }
    let mediaInfoCount =
      this.getMediaInfoList(isFromRecommend)
        .filter((mediaInfo: MediaInfoData) => mediaInfo.bundleName === currentQueueInfo?.bundleName);
    let mediaInfo = this.getMediaInfoList(isFromRecommend).find((mediaInfo: MediaInfoData) => {
      return mediaInfo.avQueueId === currentQueueInfo.avQueueId && mediaInfo.bundleName === currentQueueInfo.bundleName;
    });
    // 当前应用歌单位置前面没有其他歌单，列表中加入此歌单
    if (!mediaInfo && currentQueueInfo && mediaInfoCount && mediaInfoCount.length < 2) {
      let mediaInfoData: MediaInfoData = {
        sessionId: descriptor.sessionId || '',
        isPlaying: false,
        appIcon: await this.getAVQueueIcon(currentQueueInfo.bundleName) || '',
        queueAlbum: currentQueueInfo?.avQueueImage || '',
        queueName: currentQueueInfo?.avQueueName || '',
        hasMedia: false,
        isAVQueue: true,
        avQueueId: currentQueueInfo?.avQueueId || '',
        bundleName: currentQueueInfo?.bundleName || ''
      };
      log.showInfo(`getAvQueueCurrentIndex avQueueName: ${currentQueueInfo?.avQueueName}`);
      this.getMediaInfoList(isFromRecommend).push(mediaInfoData);
    }
  }

  private async getAppInfo(descriptor: AVSessionManager.AVSessionDescriptor, isFromRecommend: boolean) {
    let mediaInfo = this.getMediaInfoList(isFromRecommend)
      .find((mediaInfo: MediaInfoData) => mediaInfo.bundleName === descriptor?.elementName.bundleName);
    if (mediaInfo) {
      return;
    }
    // 没有歌单，将应用信息放入列表
    let mediaInfoData: MediaInfoData = {
      sessionId: descriptor.sessionId || '',
      isPlaying: false,
      appIcon: await this.getAVQueueIcon(descriptor.elementName.bundleName) || '',
      appName: await this.getAppName(descriptor.elementName.bundleName) || '',
      hasMedia: false,
      isAVQueue: false,
      bundleName: descriptor.elementName.bundleName || ''
    };
    log.showInfo(`getAppInfo: history app info.`)
    this.getMediaInfoList(isFromRecommend).push(mediaInfoData);
  }

  private async getAvQueueOthers(historicalAlbums: AVSessionManager.AVQueueInfo[],
    historyDescriptors: AVSessionManager.AVSessionDescriptor[],
    activeDescriptors: AVSessionManager.AVSessionDescriptor[], isFromRecommend: boolean) {
    for (let index = 0; index < historicalAlbums.length; index++) {
      let queueInfo = historicalAlbums[index];
      let mediaInfo = this.getMediaInfoList(isFromRecommend).find((mediaInfo: MediaInfoData) => {
        return mediaInfo.avQueueId === queueInfo.avQueueId && mediaInfo.bundleName === queueInfo.bundleName;
      });
      let descriptor = historyDescriptors.find((descriptorInfo: AVSessionManager.AVSessionDescriptor) =>
      descriptorInfo.elementName.bundleName === queueInfo.bundleName);
      if (descriptor === undefined) {
        descriptor = activeDescriptors.find((descriptorInfo: AVSessionManager.AVSessionDescriptor) =>
        descriptorInfo.elementName.bundleName === queueInfo.bundleName);
      }
      if (!mediaInfo) {
        let mediaInfoData: MediaInfoData = {
          sessionId: descriptor?.sessionId || '',
          isPlaying: false,
          appIcon: await this.getAVQueueIcon(queueInfo.bundleName) || '',
          queueAlbum: queueInfo?.avQueueImage || '',
          queueName: queueInfo?.avQueueName || '',
          hasMedia: false,
          isAVQueue: true,
          avQueueId: queueInfo?.avQueueId || '',
          bundleName: queueInfo?.bundleName || ''
        };
        log.showInfo(`getAvQueueOthers avQueueName: ${queueInfo?.avQueueName}`);
        this.getMediaInfoList(isFromRecommend).push(mediaInfoData);
      }
    }
  }

  public async getHistoricalAndRecommendData() {
    let isScreenOff = AppStorage.get('isCurScreenOn') === false;
    log.showInfo(`getHistoricalAndRecommendData isScreenOff ${isScreenOff}`);
    if (isScreenOff) {
      return;
    }

    // 歌单数据
    this.mediaInfoList = [];

    await this.getActiveAppMetaData(false);

    await this.getHistoryAvQueueInfo(false);

    this.convertMediaInfoData();
  }

  async refreshHistoricalAndRecommendData() {
    let isScreenOff = AppStorage.get('isCurScreenOn') === false;
    log.showInfo(`refreshHistoricalAndRecommendData isScreenOff ${isScreenOff}`);
    if (isScreenOff) {
      return;
    }

    // 歌单数据
    this.mediaInfoList = [];

    await this.getActiveAppMetaData(false);

    await this.getHistoryAvQueueInfo(false);

    this.convertMediaInfoData();
  }


  convertMediaInfoData() {
    log.showInfo('convertMediaInfoData');
    let mediaInfoListTemp: MediaInfoData[] = [];
    mediaInfoListTemp =
      this.mediaInfoList.filter((mediaInfo: MediaInfoData) => !(mediaInfo.hasMedia &&
        (mediaInfo.sessionId === AppStorage.get('CurSessionId'))));
    let mediaInfoList: MediaInfoData[] = [];
    if (mediaInfoListTemp.length > 3) {
      mediaInfoList = mediaInfoListTemp.slice(0, 3);
    } else {
      mediaInfoList = mediaInfoListTemp;
    }
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { mediaInfoListData: mediaInfoList });
    }
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

  /**
   * 设置isExistAvQueueInfo的个数是否大于2个
   */
  async isExistAvQueueStateUpdate() {
    // 活跃应用的个数
    let sessionDescriptors = await AVSessionManager.getAllSessionDescriptors();
    if (sessionDescriptors.length >= 2) {
      this.setIsShowRecentlyList(true);
      return;
    }

    // 活跃+历史应用个数
    let historicalSessionDescriptors = await AVSessionManager.getHistoricalSessionDescriptors();
    if (historicalSessionDescriptors.length + sessionDescriptors.length >= 2) {
      this.setIsShowRecentlyList(true);
      return;
    }
    // 走到这里说明只有一个活跃应用或者历史应用
    // 歌单的个数
    let avQueueInfo = await AVSessionManager.getHistoricalAVQueueInfos(5, 5);
    if (avQueueInfo.length >= 2) {
      this.setIsShowRecentlyList(true);
      return;
    }

    // 只有一个歌单，一定是属于当前应用
    this.setIsShowRecentlyList(false);
  }

  setIsShowRecentlyList(isExist: boolean) {
    this.isExistAvQueueInfoLink.set(isExist);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { isExistAvQueueInfo: isExist });
    }
  }

  private getMediaInfoList(isFromRecommend: boolean): MediaInfoData[] {
    if (isFromRecommend) {
      return this.mediaInfoListRecommend;
    } else {
      return this.mediaInfoList;
    }
  }

  async getUserId() {
    log.showInfo('try get source icon getUserId start ');
    const osAccountManager = osAccount.getAccountManager();
    let userId: number = 0;
    try {
      let localAccountInfo : number[] = await osAccountManager.queryActivatedOsAccountIds();
      log.showInfo(`getUserId localId ${localAccountInfo}`);
      for (let j = 0; j < localAccountInfo.length; j++) {
        let localId :number = localAccountInfo[j];
        if (localId != 0) {
          userId = localId;
        }
      }
    } catch (err) {
      log.error(`getUserId by elementName err : ${err}`);
    }
    return userId;
  }

  async getBundleInfo(bundleName: string, abilityName: string):
    Promise<string | image.PixelMap | boolean | undefined> {
    log.showInfo(`getBundleInfo with bundleName: ${bundleName} abilityName: ${abilityName}`);
    const showBundle: string | image.PixelMap | boolean | undefined =
      await this.sessionProvider?.getShowingBundle(bundleName, abilityName);
    return showBundle;
  }

  async refreshFavoriteEnable(sessionId: string, avSessionController: AVSessionManager.AVSessionController) {
    log.showInfo(`get favorite command enable for session: ${sessionId?.length < 10 ? '' :
      (sessionId?.substr(0, 5) + '**' + sessionId?.substr(sessionId?.length - 5))}`);
    let enableCommand : AVSessionManager.AVControlCommandType[] = [];
    let enableCommandsArray : AVSessionManager.AVControlCommandType[] =
      await this.commonInterface?.getValidCommands(sessionId) || [];

    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId] as string;
    log.showInfo(` refreshFavoriteEnable check bundle ${bundleName}`);
    let version: string = this.sessionProvider?.appVersionMap.get(bundleName) || 'default';
    let metaDataMap = this.metaDataMapLink.get();
    let isDuration: boolean = metaDataMap[sessionId].duration !== undefined;
    for (let j = 0; j < enableCommandsArray.length; j++) {
      log.debug(` check enable command: ${enableCommandsArray[j]}`);
      enableCommand.push(enableCommandsArray[j]);
    }
    log.showInfo(' get enable command enable done with ' + JSON.stringify(enableCommand));
    let tempEnableCommandMap = this.commandEnableMapLink.get();
    tempEnableCommandMap[sessionId] = enableCommand;
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    const dfxParam : DfxParam = {
      PNAMEID: this.pInfoName,
      PVERSIONID: this.pInfoVersion,
      SUPPORTACTION: enableCommand,
      DEVICEMODELTYPE: MediaInfoProvider.getInstance().getDeviceModelType(),
      APP_TYPE: appType,
      CONTROL_APP_VERSION_NAME: version,
      CONTROL_BUNDLE_NAME: bundleName,
      SUPPORT_DURATION: isDuration
    };
    HiSysEvent.getEventParam(EventType.MEDIA_CONTROL_ACTIVE)
      .updateAllExtendParam(dfxParam)
      .reportEvent(true);
    this.commandEnableMapLink.set(tempEnableCommandMap);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { sessionId, validCommands: enableCommand });
    }
  }

  async refreshPlayState(controller: AVSessionManager.AVSessionController) {
    log.showInfo(`refresh play state for session: ${controller.sessionId?.length < 10 ? '' :
      (controller.sessionId?.substr(0, 5) + '**' + controller.sessionId?.substr(controller.sessionId?.length - 5))}`);
    return this.commonInterface?.getAVPlaybackState(controller.sessionId)
      .then(data => {
        const playState: AVSessionManager.AVPlaybackState = data.value;
        const playStateMap = this.playStateMapLink.get();
        log.showInfo(`getAVPlaybackState refresh: ${playState.state}, ${playState.isFavorite}, ${data.type}`);
        if (playStateMap && playStateMap[controller.sessionId] && playState.state == undefined) {
          playState.state = playStateMap[controller.sessionId].state;
        }
        if (playState.isFavorite == undefined && data.type === 'cast') {
          playState.isFavorite = false;
        } else if (playStateMap && playStateMap[controller.sessionId] && playState.isFavorite == undefined) {
          playState.isFavorite = playStateMap[controller.sessionId].isFavorite;
        }
        if (playStateMap && playStateMap[controller.sessionId] &&
          (!playState.position || playState.position.elapsedTime < 0 || playState.position.updateTime < 0)) {
          let oldPosition: AVSessionManager.PlaybackPosition = playStateMap[controller.sessionId].position;
          log.showInfo(`get repo save old position: ${JSON.stringify(oldPosition)}`);
          playState.position = oldPosition;
        }
        playStateMap[controller.sessionId] = playState;
        this.playStateMapLink.set(playStateMap);
        if (this.enableDc) {
          // 通知子线程
          messageChannel.sendMessage('syncSubData', { sessionId: controller.sessionId, playState: playState});
        }
        const playbackPositionMap = this.playbackPositionMapLink.get();
        if (!playbackPositionMap[controller.sessionId]) {
          playbackPositionMap[controller.sessionId] = {elapsedTime:0, updateTime: 0} as NewTime;
        }
        if (playState.position !== undefined) {
          log.showInfo(`getAVPlaybackState refresh position: ${JSON.stringify(playState.position)},`);
          playbackPositionMap[controller.sessionId] = playState.position;
        }
        this.playbackPositionMapLink.set(playbackPositionMap);
        if (this.enableDc) {
          // 通知子线程
          messageChannel.sendMessage('syncSubData', { sessionId: controller.sessionId, position: playState.position});
        }
        if (data.type === 'cast' && playState.volume !== undefined) {
          log.showInfo(`getAVPlaybackState: update volume: ${playState.volume}, ${playState.extras?.maxCastVolume}`);
          const targetVolume = Math.round(Constants.VOLUME_SLIDER_MAX * playState.volume / Constants.CAST_VOLUME_MAX);
          const maxCastVolume = playState.extras?.maxCastVolume as number || Constants.CAST_DEVICE_VOLUME_MAX_DEFAULT;
          this.volumeManager?.setCastVolumeParams(0, maxCastVolume,
            Math.round(playState.volume * maxCastVolume / Constants.CAST_VOLUME_MAX));
          this.volumeManager?.updateVolumeSet(targetVolume, SetVolumeType.CAST, true);
        }
      })
      .catch((err : BusinessError.BusinessError) => {
        log.showInfo(`fail to get play state: ${JSON.stringify(err)}`);
      });
  }

  refreshVolume(sessionId: string) {
    log.showInfo(`refresh volume now: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    this.commonInterface?.getCurrentVolume(sessionId)
      .then(data => {
        if (data) {
          log.showInfo(`refresh volume suc: ${JSON.stringify(data)}`);
          this.volumeManager?.updateVolumeSet(data.value,
            data.type === 'local' ? SetVolumeType.AUDIO : SetVolumeType.CAST, true);
        }
      })
      .catch((err : BusinessError.BusinessError) => {
        log.showInfo(`refresh volume fail: ${JSON.stringify(err)}`);
      })
  }

  dealPlaybackStateChanged(state : AVSessionManager.AVPlaybackState, type : string, sessionId: string) {
    if (!state) {
      log.error('playback state info is null');
      return;
    }
    if (!this.playStateMapLink) {
      log.showInfo(`dealPlaybackStateChanged-playStateMapLink in null`);
      return;
    }
    this.updateRecentlyPlayListPlayState(state, sessionId);
    if (!this.sessionProvider?.checkIsTopSession(sessionId)) {
      log.showInfo(`not top session`);
      return;
    }
    this.playbackReport(state, sessionId);
    log.showInfo(`playBackStateChange: playback state: ${JSON.stringify(state)}, type: ${type}, Id:
      ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' + sessionId?.substr(sessionId?.length - 5))}`);
    let playStateMap = this.playStateMapLink.get();
    if (playStateMap && playStateMap[sessionId] && state.state == undefined) {
      state.state = playStateMap[sessionId].state;
    }
    if (state.isFavorite == undefined && type === 'cast') {
      state.isFavorite = false;
    } else if (playStateMap && playStateMap[sessionId] && state.isFavorite == undefined) {
      state.isFavorite = playStateMap[sessionId].isFavorite;
    }
    if (playStateMap && playStateMap[sessionId] && state.loopMode == undefined) {
      state.loopMode = playStateMap[sessionId].loopMode;
    }
    if (this.seekFlag && state.position) {
      state.position = undefined;
    }
    playStateMap[sessionId] = state;
    this.playStateMapLink.set(playStateMap);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { sessionId, playState: state});
    }
    if (type === 'cast' && state.volume !== undefined) {
      log.showInfo(`playBackStateChange: update volume: ${state.volume}, ${state.extras?.maxCastVolume}`);
      const targetVolume = Math.round(Constants.VOLUME_SLIDER_MAX * state.volume / Constants.CAST_VOLUME_MAX);
      const maxCastVolume = state.extras?.maxCastVolume as number || Constants.CAST_DEVICE_VOLUME_MAX_DEFAULT;
      this.volumeManager?.setCastVolumeParams(0, maxCastVolume,
        Math.round(state.volume * maxCastVolume / Constants.CAST_VOLUME_MAX));
      this.volumeManager?.updateVolumeSet(targetVolume, SetVolumeType.CAST, true);
    }
    let playbackPositionMap = this.playbackPositionMapLink.get();
    if (state.position !== undefined) {
      log.showInfo(`playBackStateChange: update position: ${JSON.stringify(state.position)}`);
      playbackPositionMap[sessionId] = state.position;
    }
    this.playbackPositionMapLink.set(playbackPositionMap);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { sessionId, position: state.position});
    }
  }

  updateRecentlyPlayListPlayState(state: AVSessionManager.AVPlaybackState, sessionId: string) {
    if (!state || !sessionId) {
      return;
    }
    let isUpdate: boolean = false;
    this.mediaInfoList.forEach((item: MediaInfoData) => {
      if (item.hasMedia && item.sessionId === sessionId) {
        isUpdate = true;
        if (state && state.state) {
          item.isPlaying = state.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
            state.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING;
        }
      }
    })
    if (isUpdate) {
      this.convertMediaInfoData();
    }
  }

  async dealMetadataChange(data : AVSessionManager.AVMetadata | null,
                           type : string, sessionController: AVSessionManager.AVSessionController) {
    log.showInfo(`Metadata DATA: ${JSON.stringify(data)} `);
    if (!data) {
      log.error('Metadata data is null ');
      return;
    }
    let sessionId: string = sessionController.sessionId;
    let metaDataMap = this.metaDataMapLink.get();
    let oldData: AVSessionManager.AVMetadata | undefined = metaDataMap[sessionId];
    this.metadataReport(data, oldData, sessionId);
    // assetId不变时，执行增量更新
    let isIncremental: boolean = !!(oldData?.assetId && oldData?.assetId === data.assetId);
    log.showInfo(`Metadata change callback img: ${JSON.stringify(data)} | ${data.title} |
      ${data.artist} | ${data.mediaImage}, ${type}`);
    this.initPosition(sessionId, isIncremental);
    try {
      if (typeof data.mediaImage === 'string' &&
      data.mediaImage.startsWith('http')) {
        log.showInfo('clickDataUpdate,dealMetadataChange');
        data.mediaImage = await this.downloadImage(data.mediaImage as string, sessionController.sessionId);
        log.showInfo('Metadata change image fresh with string type ');
      } else if (data.mediaImage && typeof data.mediaImage !== 'string') {
        await this.getPixelImageInfo(data.mediaImage, sessionId);
      } else if (typeof data.mediaImage === 'string' && data.mediaImage.startsWith('http')) {
        data.mediaImage = undefined;
        log.showInfo(`Metadata change image undefined`);
      } else {
        log.showInfo('Metadata change image fresh with other type');
      }
      this.refreshRecentlyListMetadata(data, sessionId);
      let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
      let songInfo: SongInfo = {};
      if (bundleName === 'com.ohos.music' && data.description) {
        songInfo = this.getSongInfo(data.description);
      }
      if (data.lyric && songInfo && songInfo.songName && songInfo.songArtist) {
        data.title = songInfo.songName + '-' + songInfo.songArtist;
      } else if (data.lyric && data.title !== undefined && (data.artist !== undefined || data.subtitle !== undefined)) {
        data.title = data.title + '-' + (data.artist || data.subtitle);
      }
      if (GlobalContext.getInstance().getObject('isMediaCenterShow')) {
        if (type === 'locale') {
          // 增量更新
          metaDataMap[sessionId] = isIncremental && !!oldData ?
            combineObject(oldData, data) as Partial<AVSessionManager.AVMetadata> : data;
        } else {
          log.showInfo(`cast or local type error`);
          return;
        }
        this.metaDataMapLink.set(metaDataMap);
        if (this.enableDc) {
          // 通知子线程
          messageChannel.sendMessage('syncSubData', { sessionId, metadata: metaDataMap[sessionId] });
        }
        log.showInfo('Metadata change callback img: done');
      }
    } catch (err) {
      console.error('Metadata change image error: ', JSON.stringify(err));
    }
  }

  refreshRecentlyListMetadata(data : AVSessionManager.AVMetadata | null, sessionId: string) {
    if (!data || !sessionId) {
      return;
    }
    // 是否是置顶的  置顶的不全量刷新
    for (let mediaInfo of this.mediaInfoList) {
      if (mediaInfo.isAVQueue && mediaInfo.avQueueId === data.avQueueId) {
        this.refreshHistoricalAndRecommendData();
        return;
      }
    }
    let isUpdate: boolean = false;
    for (let item of this.mediaInfoList) {
      if (item.hasMedia && item.sessionId === sessionId) {
        isUpdate = true;
        if (data.title) {
          item.title = data.title;
        }
        if (data.author) {
          item.author = data.author;
        }
        if (data.mediaImage) {
          item.album = data.mediaImage;
        }
        if (data.avQueueId) {
          item.avQueueId = data.avQueueId;
        }
      }
    }
    if (isUpdate) {
      this.convertMediaInfoData();
    }
  }

  initPosition(sessionId: string, isIncremental: boolean) {
    let playStateMap = this.playStateMapLink.get();
    if (isIncremental || !playStateMap[sessionId]) {
      return;
    }
    this.seekFlag = false;
    let state: AVSessionManager.AVPlaybackState = ObjectCopyUtil.deepClone(playStateMap[sessionId]);
    state.position = {
      elapsedTime: 0,
      updateTime: new Date().getTime()
    }
    playStateMap[sessionId] = state;
    this.playStateMapLink.set(playStateMap);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { sessionId, playState: playStateMap[sessionId]});
    }
  }

  getSongInfo(data: string):SongInfo {
    let songInfo: SongInfo = {};
    let songInfoList = data.split(';');
    songInfo.songName = songInfoList[0];
    songInfo.songArtist = songInfoList[1];
    return songInfo;
  }

  async setAVSessionContentListener(sessionController: AVSessionManager.AVSessionController,
                                    isUpdate = false) {
    let sessionId: string = sessionController.sessionId;
    log.showInfo(`Start set AVSession listener for session: ${sessionId?.length < 10 ? '' :
      (sessionId?.substr(0, 5) + '**' + sessionId?.substr(sessionId?.length - 5))}, ${isUpdate}`);
    if (!sessionController) {
      log.showInfo(' set AVSession listener but avSessionController is null ');
      return;
    }
    this.commonInterface?.onPlaybackStateChanged(sessionController, isUpdate, (state, type): void =>
    this.dealPlaybackStateChanged(state, type, sessionId));

    this.commonInterface?.onMetadataChange(sessionController, isUpdate, async (data, type): Promise<void> => {
      this.dealMetadataChange(data, type, sessionController);
      this.reFreshDeviceFilter(data, sessionController);
    });
    await this.commonInterface?.onValidCommandChange(sessionController, isUpdate, async (commands): Promise<void> => {
      if (!GlobalContext.getInstance().getObject('isMediaCenterShow')) {
        return;
      }
      let tempEnableCommandMap = this.commandEnableMapLink.get();
      tempEnableCommandMap[sessionId] = commands;
      this.commandEnableMapLink.set(tempEnableCommandMap);
      if (this.enableDc) {
        // 通知子线程
        messageChannel.sendMessage('syncSubData', { sessionId, validCommands: commands });
      }
    });
    log.showInfo('set AVSession content listener end');
  }

  checkIsSinkSession(sessionId: string): boolean {
    if (this.sessionProvider == undefined) {
      log.showInfo(`checkIsSinkSession check without session provider`);
      return false;
    }
    let descriptor: AVSessionManager.AVSessionDescriptor = this.sessionProvider?.avSessionDescriptorMap[sessionId];
    if (descriptor == undefined) {
      log.showInfo(`checkIsSinkSession check without session descriptor`);
      return false;
    }
    log.showInfo(`checkIsSinkSession check with type ${descriptor.sessionTag}`);
    let result: boolean = descriptor.sessionTag === 'RemoteCast';
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncIsSinkSession', { isSinkSession: result });
    }
    return result;
  }

  getCurrentDeviceType(): number {
    let deviceType: number | undefined = AppStorage.get<LocalDeviceInfo>('CurDeviceSelect')?.deviceType;
    if (!deviceType) {
      log.error('devType get error!!')
      deviceType = 0; //无效设备
    }
    return deviceType;
  }

  /**
   * 调节音量
   * @param volume
   * @param mode
   * @param sessionId
   */
  callVolumeChange(volume: number, mode: number, sessionId?: string) {
    log.showInfo(`callVolumeChange ${volume}, ${mode}`);
    this.commonInterface?.setVolume(volume, mode, sessionId);
  }

  /**
   * 调节音量（物理按键）
   * @param type
   * @param inputType
   * @param sessionId
   */
  async callVolumeInput(volumeType: SetVolumeType, actionType: InputVolumeAction, sessionId?: string) {
    log.showInfo(`callVolumeInput ${volumeType}, ${actionType}`);
    if (this.volumeManager) {
      let volume = await this.volumeManager.getNextVolume(volumeType, actionType);
      this.commonInterface?.setVolume(volume, SliderChangeMode.End, sessionId);
    }
  }

  /**
   * 设置投播音量
   * @param sessionId
   * @param actionType
   */
  callCastVolumeChange(sessionId: string, actionType: InputVolumeAction) {
    this.commonInterface?.setCastVolume(sessionId, actionType);
  }

  // 雷达打点
  public reportRader(funcName: string, bizScene: number, bizStage: number, stageRes: number, bizState: number,
                     extras: PartialRadaParam = {}) {
    const param: RadarParam = {
      ORG_PKG: radarBunldName,
      TO_CALL_PKG: 'av_session',
      TRIGGER_MODE: AppStorage.get('selectMode') === 'checkbox' ?
        TriggerMode.mediaDeviceListCast : TriggerMode.appComponentCast,
      FUNC: funcName,
      BIZ_SCENE: bizScene,
      BIZ_STAGE: bizStage,
      STAGE_RES: stageRes,
      BIZ_STATE: bizState,
    };
    const radarParam: RadarParam = combineObject(param, extras) as RadarParam;
    this.sessionProvider?.reportScenesHiEvent(EventType.MEDIA_CONTROL_CAST_BEHAVIOR, radarParam, false);
  }

  // 用户行为打点
  public reportUE(eventType: EventType, sessionId: string, reason:string, isJump: boolean = false) {
    clearTimeout(this.controlEventTimeId.get(eventType));
    this.controlEventTimeId.set(eventType, undefined);
    this.controlEventMap.set(eventType, false);
    let startTime = this.controlEventStartTime.get(eventType) || new Date().getTime();
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    let version: string = this.sessionProvider?.appVersionMap.get(bundleName) || 'default';
    let devType: number = this.getCurrentDeviceType();
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    let dfxParam: DfxParam = {
      PNAMEID: this.pInfoName,
      PVERSIONID: this.pInfoVersion,
      PACKAGE_NAME: bundleName,
      DEVICE_TYPE: devType,
      CONTROLINTERFACE: globalStorage.getNumberByKey('isShowSwitch'),
      TIME: startTime,
      SCREENSTATUS: this.getScreenStatus(),
      DEVICEMODELTYPE: this.getDeviceModelType(),
      SCREENFOLDEDSTATUS: this.getFold(),
      CONTROL_RESULT: reason,
      PACKAGE_VERSION: version
    };
    if (!isJump) {
      dfxParam.TIME_COST = new Date().getTime() - startTime;
      dfxParam.APP_TYPE = appType;
    }
    let extraParam: DfxParam = this.controlEventExtras.get(eventType) || {};
    dfxParam = combineObject(dfxParam, extraParam) as DfxParam;
    this.sessionProvider?.reportScenesHiEvent(eventType, dfxParam, true);
  }

  // 回调超时打点
  timeoutReportUE(eventType: EventType, sessionId: string, extras: DfxParam = {}) {
    let reason = 'playbackState or metadata change timeout';
    if (this.controlEventTimeId.get(eventType)) {
      log.showInfo(`timeoutReportUE eventType${eventType} has timer, return`);
      return;
    }
    this.controlEventMap.set(eventType, true);
    this.controlEventStartTime.set(eventType, new Date().getTime());
    this.controlEventExtras.set(eventType, extras);
    this.controlEventTimeId.set(eventType, setTimeout(() => {
      this.reportUE(eventType, sessionId, reason);
    }, extras.COLD_START ? 10000 : 3000));
  }

  // 状态回调正常打点
  playbackReport(state : AVSessionManager.AVPlaybackState, sessionId: string) {
    this.controlEventMap.forEach((value, eventType) => {
      if (!value || !state || !sessionId) {
        return;
      }
      if (state.state) {
        this.statePlaybackReport(eventType as EventType, state.state, sessionId);
      }
      if (state.position) {
        this.positionPlaybackReport(eventType as EventType, state.position, sessionId);
      }
      if (state.loopMode !== undefined || state.isFavorite !== undefined) {
        this.loopOrFavoritePlaybackReport(eventType as EventType, state, sessionId);
      }
    })
  }

  // 播放状态回调打点
  statePlaybackReport(eventType: EventType, state: AVSessionManager.PlaybackState, sessionId: string) {
    if (eventType === EventType.LOCAL_DEVICE_PLAY) {
      // 冷启动特殊处理
      if (this.controlEventExtras.get(eventType)?.COLD_START) {
        this.coldStartPlayback = true;
        if (this.coldStartPlayback && this.coldStartMetadata) {
          this.coldStartPlayback = false;
          this.coldStartMetadata = false;
          this.reportUE(eventType, sessionId, 'SUCCESS');
        }
      } else {
        if (state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY) {
          this.reportUE(eventType, sessionId, 'SUCCESS');
        } else if (state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PAUSE) {
          this.reportUE(eventType, sessionId, 'PLAYBACKSTATE_CHANGE_ERROR');
        }
      }
    } else if (eventType === EventType.LOCAL_DEVICE_PAUSE) {
      if (state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PAUSE) {
        this.reportUE(eventType, sessionId, 'SUCCESS');
      } else {
        this.reportUE(eventType, sessionId, 'PLAYBACKSTATE_CHANGE_ERROR');
      }
    }
  }

  // 进度状态回调打点
  positionPlaybackReport(eventType: EventType, position: AVSessionManager.PlaybackPosition, sessionId: string) {
    if (eventType === EventType.LOCAL_DEVICE_FASTFORWARD || eventType === EventType.LOCAL_DEVICE_REWIND ||
      eventType === EventType.LOCAL_DEVICE_SEEK) {
      let isVideo: boolean = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type === 'video';
      let time: number = this.controlEventSeekTime.get(eventType) as number - position.elapsedTime;
      if ((time >= (isVideo ? 3000 : 100)) || (time <= (isVideo ? -3000 : -100))) {
        this.reportUE(eventType, sessionId, 'PLAYBACKSTATE_CHANGE_ERROR');
      } else {
        this.reportUE(eventType, sessionId, 'SUCCESS');
      }
    }
  }

  // 收藏或者循环状态回调打点
  loopOrFavoritePlaybackReport(eventType: EventType, state: AVSessionManager.AVPlaybackState, sessionId: string) {
    if (eventType === EventType.LOCAL_DEVICE_LOOPMODE && state.loopMode !== undefined) {
      if (state.loopMode === this.controlEventExtras.get(eventType)?.CONTROL_MODE) {
        this.reportUE(eventType, sessionId, 'PLAYBACKSTATE_CHANGE_ERROR');
      } else {
        this.controlEventExtras.set(eventType, { CONTROL_MODE: state.loopMode })
        this.reportUE(eventType, sessionId, 'SUCCESS');
      }
    } else if (eventType === EventType.LOCAL_FAVORITE && state.isFavorite !== undefined) {
      if (state.isFavorite === !!(this.controlEventExtras.get(eventType)?.CONTROL_MODE)) {
        this.reportUE(eventType, sessionId, 'PLAYBACKSTATE_CHANGE_ERROR');
      } else {
        this.controlEventExtras.set(eventType, { CONTROL_MODE: state.isFavorite ? 1 : 0 })
        this.reportUE(eventType, sessionId, 'SUCCESS');
      }
    }
  }

  // 信息回调正常打点
  metadataReport(newData: AVSessionManager.AVMetadata, oldData: AVSessionManager.AVMetadata | undefined,
                 sessionId: string) {
    this.controlEventMap.forEach((value, eventType) => {
      if (!value) {
        return;
      }
      let lastTitleMap = this.lastTitleMapLink;
      if (eventType === EventType.LOCAL_DEVICE_NEXT || eventType === EventType.LOCAL_DEVICE_PREVIOUS) {
        if (newData.assetId !== oldData?.assetId || newData.title !== lastTitleMap[sessionId]) {
          this.reportUE(eventType, sessionId, 'SUCCESS');
        } else {
          this.reportUE(eventType, sessionId, 'METADATA_ERROR');
        }
        lastTitleMap[sessionId] = newData.title;
        this.lastTitleMapLink = lastTitleMap;
      } else if ((eventType === EventType.LOCAL_DEVICE_PLAY && this.controlEventExtras.get(eventType)?.COLD_START) ||
        (newData.assetId !== undefined || newData.title !== undefined)) {
        this.coldStartMetadata = true;
        if (this.coldStartPlayback && this.coldStartMetadata) {
          this.coldStartPlayback = false;
          this.coldStartMetadata = false;
          this.reportUE(eventType as EventType, sessionId, 'SUCCESS');
        }
      }
    })
  }

  async callFavorites(sessionId: string, isFavorites?: boolean): Promise<void> {
    log.showInfo(`callFavorites: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}, isFavorites: ${isFavorites},`);
    this.timeoutReportUE(EventType.LOCAL_FAVORITE, sessionId, { CONTROL_MODE: isFavorites ? 1 : 0 });
    let getSessionController: SessionController | undefined =
      await this.commonInterface?.getCurrentController(sessionId);
    let that = this;
    let metaDataMap: Map<string, AVSessionManager.AVMetadata> = that.metaDataMapLink.get();
    let metaData: AVSessionManager.AVMetadata = metaDataMap[sessionId];
    let assetId: string = metaData.assetId;
    let favorites: AVSessionManager.AVControlCommand = { command: 'toggleFavorite', parameter: assetId };
    if (SessionInfoProvider.isQuiting) {
      log.showInfo('is quiting, return ');
      return;
    }
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    await this.commonInterface?.sendControlCommand(sessionId, favorites).then(() => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callFavorites cast');
        this.reportRader('callFavorites', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.idle, BizState.start);
      }
    }).catch((errorCode : BusinessError.BusinessError) => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callFavorites cast fail');
        this.reportRader('callFavorites', BizScene.sourceController, SourceController.sendControlCommand,
          isFavorites === true ? StageResult.sussess : StageResult.fail, BizState.ending,
          { ERROR_CODE: errorCode.code });
      }
      let dfxParam : DfxParam = { PACKAGE_NAME : bundleName, REASON: errorCode.message, OPERATE_TYPE: 'FAVORITES',
        COLD_START: false, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }

  async callForward(sessionId: string, movePosition: number) {
    log.showInfo(`callForward: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    let getSessionController: SessionController | undefined =
      await this.commonInterface?.getCurrentController(sessionId);
    if (!this.sessionProvider) {
      log.error(' next operate sessionProvider is null');
      return;
    }
    let metaDataMap: Map<string, AVSessionManager.AVMetadata> = this.metaDataMapLink.get();
    let metaDataTemp: AVSessionManager.AVMetadata = metaDataMap[sessionId];
    let interval: AVSessionManager.SkipIntervals = AVSessionManager.SkipIntervals.SECONDS_15;
    if (metaDataTemp != undefined && metaDataTemp.skipIntervals != undefined) {
      interval = metaDataTemp.skipIntervals;
    }
    let fastForwardTime = movePosition + interval;
    let duration = metaDataTemp.duration as number;
    fastForwardTime = (fastForwardTime > duration) ? duration : fastForwardTime;
    this.controlEventSeekTime.set(EventType.LOCAL_DEVICE_FASTFORWARD, fastForwardTime);
    this.timeoutReportUE(EventType.LOCAL_DEVICE_FASTFORWARD, sessionId, { CONTROL_TIME: interval });
    let fastForward: AVSessionManager.AVControlCommand = { command: 'fastForward', parameter: interval };
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    if (SessionInfoProvider.isQuiting) {
      log.showInfo('is quiting, return ');
      return;
    }
    let devType: number = this.getCurrentDeviceType();
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    await this.commonInterface?.sendControlCommand(sessionId, fastForward).then(() => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callForward cast');
        let extraParam: PartialRadaParam = { CONTROL_TIME: interval, DEVICE_TYPE: devType };
        this.reportRader('callForward', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.idle, BizState.start, extraParam);
      }
    }).catch((errorCode : BusinessError.BusinessError) => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callForward cast fail');
        let extraParam: PartialRadaParam = { ERROR_CODE: errorCode.code, CONTROL_TIME: interval, DEVICE_TYPE: devType };
        this.reportRader('callForward', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.fail, BizState.ending, extraParam);
      }
      let dfxParam : DfxParam = { PACKAGE_NAME : bundleName, REASON: errorCode.message, OPERATE_TYPE: 'FASTFORWARD',
        COLD_START: false, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }

  async callRewind(sessionId: string, movePosition: number) {
    log.showInfo(`callRewind: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    let getSessionController: SessionController | undefined =
      await this.commonInterface?.getCurrentController(sessionId);
    if (!this.sessionProvider) {
      log.error(' next operate sessionProvider is null');
      return;
    }
    let metaDataMap: Map<string, AVSessionManager.AVMetadata> = this.metaDataMapLink.get();
    let metaDataTemp: AVSessionManager.AVMetadata = metaDataMap[sessionId];
    log.showInfo(' callRewind:' + JSON.stringify(metaDataTemp));
    let interval: AVSessionManager.SkipIntervals = AVSessionManager.SkipIntervals.SECONDS_15;
    if (metaDataTemp != undefined && metaDataTemp.skipIntervals != undefined) {
      log.showInfo(' callRewind with interval :' + metaDataTemp.skipIntervals);
      interval = metaDataTemp.skipIntervals;
    }
    let rewindTime = (movePosition - interval) < 0 ? 0 : (movePosition - interval);
    this.controlEventSeekTime.set(EventType.LOCAL_DEVICE_REWIND, rewindTime);
    this.timeoutReportUE(EventType.LOCAL_DEVICE_REWIND, sessionId, { CONTROL_TIME: interval });
    let rewind: AVSessionManager.AVControlCommand = { command: 'rewind', parameter: interval };
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    if (SessionInfoProvider.isQuiting) {
      log.showInfo('is quiting, return ');
      return;
    }
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    await this.commonInterface?.sendControlCommand(sessionId, rewind).then(() => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callRewind cast');
        this.reportRader('callRewind', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.idle, BizState.start);
      }
    }).catch((errorCode : BusinessError.BusinessError) => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callRewind cast fail');
        this.reportRader('callRewind', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.fail, BizState.ending, { ERROR_CODE: errorCode.code });
      }
      let dfxParam : DfxParam = { PACKAGE_NAME : bundleName, REASON: errorCode.message, OPERATE_TYPE: 'REWIND',
        COLD_START: false, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }

  async callSeek(sessionId: string, time: number) {
    this.controlEventSeekTime.set(EventType.LOCAL_DEVICE_SEEK, time);
    this.timeoutReportUE(EventType.LOCAL_DEVICE_SEEK, sessionId);
    let getSessionController: SessionController | undefined =
      await this.commonInterface?.getCurrentController(sessionId);
    if (!this.sessionProvider) {
      log.error(' next operate sessionProvider is null');
      return;
    }
    let seek: AVSessionManager.AVControlCommand = { command: 'seek', parameter: time };
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    if (SessionInfoProvider.isQuiting) {
      log.showInfo('is quiting, return ');
      return;
    }
    let playbackPositionMap = this.playbackPositionMapLink.get();
    if (playbackPositionMap[sessionId]) {
      playbackPositionMap[sessionId] = {
        elapsedTime: seek.parameter, updateTime: new Date().getTime(),
      };
    }
    this.playbackPositionMapLink.set(playbackPositionMap);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { sessionId, position: playbackPositionMap[sessionId]});
    }
    let playStateMap = this.playStateMapLink.get();
    if (playStateMap[sessionId]) {
      playStateMap[sessionId].position = {
        elapsedTime: seek.parameter, updateTime: new Date().getTime(),
      };
    }
    this.playStateMapLink.set(playStateMap);
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { sessionId, playState: playStateMap[sessionId]});
    }
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;

    await this.commonInterface?.sendControlCommand(sessionId, seek).then(() => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callSeek cast');
        this.reportRader('callSeek', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.idle, BizState.start);
      }
    }).catch((errorCode : BusinessError.BusinessError) => {
      if (getSessionController?.type !== LOCAL) {
        // 清除seek标记
        this.seekFlag = false;
        // 雷达打点
        log.showInfo('callSeek cast fail');
        this.reportRader('callSeek', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.fail, BizState.ending, { ERROR_CODE: errorCode.code });
      }
      let dfxParam : DfxParam = { PACKAGE_NAME : bundleName, REASON: errorCode.message, OPERATE_TYPE: 'SEEK',
        COLD_START: false, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }
  async reFreshDeviceFilter(data: AVSessionManager.AVMetadata | null, sessionController:
    AVSessionManager.AVSessionController) {
    if (!data) {
      log.error('Metadata data is null ');
      return;
    }
    log.showInfo(`get filter ${data?.filter} | ${this.deviceFilter}`);
    if (data?.filter !== undefined && this.deviceFilter !== undefined) {
      if (data?.filter === avSession.ProtocolType.TYPE_LOCAL) {
        CastDeviceControl.deviceManager?.stopCast();
      } else if (data?.filter !== this.deviceFilter) {
        CastDeviceControl.deviceManager?.start(sessionController.sessionId, false);
      }
      this.deviceFilter = data?.filter;
      AppStorage.setAndRef('deviceFilter', this.deviceFilter);
    }
    this.deviceFilter = data?.filter;
    AppStorage.setAndRef('deviceFilter', this.deviceFilter);
  }

  async callNext(sessionId: string) {
    log.showInfo(`callNext: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    this.timeoutReportUE(EventType.LOCAL_DEVICE_NEXT, sessionId);
    let getSessionController: SessionController | undefined =
      await this.commonInterface?.getCurrentController(sessionId);
    if (!this.sessionProvider) {
      log.error(' next operate sessionProvider is null');
      return;
    }
    let next: AVSessionManager.AVControlCommand = { command: 'playNext' };
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    if (SessionInfoProvider.isQuiting) {
      log.showInfo('is quiting, return ');
      return;
    }
    await this.commonInterface?.sendControlCommand(sessionId, next).then(() => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callNext cast');
        this.reportRader('callNext', BizScene.sourceController, SourceController.sendPrevNextCommand,
          StageResult.idle, BizState.start);
        this.isStartCastLink.set(true);
      }
    }).catch((errorCode : BusinessError.BusinessError) => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callNext cast fail');
        this.reportRader('callNext', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.fail, BizState.ending, { ERROR_CODE: errorCode.code });
      }
      let dfxParam : DfxParam = { PACKAGE_NAME : bundleName, REASON: errorCode.message, OPERATE_TYPE: 'NEXT',
        COLD_START: false, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }

  async callPrevious(sessionId: string) {
    log.showInfo(`callPrevious: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    this.timeoutReportUE(EventType.LOCAL_DEVICE_PREVIOUS, sessionId);
    let getSessionController: SessionController | undefined =
      await this.commonInterface?.getCurrentController(sessionId);
    let previous: AVSessionManager.AVControlCommand = { command: 'playPrevious' };
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    if (SessionInfoProvider.isQuiting) {
      log.showInfo('is quiting, return ');
      return;
    }
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    await this.commonInterface?.sendControlCommand(sessionId, previous).then(() => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callPrevious cast');
        this.reportRader('callPrevious', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.idle, BizState.start);
        this.isStartCastLink.set(true);
      }
    }).catch((errorCode : BusinessError.BusinessError) => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callPrevious cast fail');
        this.reportRader('callPrevious', BizScene.sourceController, SourceController.sendPrevNextCommand,
          StageResult.fail, BizState.ending, { ERROR_CODE: errorCode.code });
      }
      let dfxParam : DfxParam = { PACKAGE_NAME : bundleName, REASON: errorCode.message, OPERATE_TYPE: 'PREVIOUS',
        COLD_START: false, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }

  async callPlay(sessionId: string, isColdStart: boolean, isForceTopSession: boolean = false) {
    log.showInfo(`callPlay: ${isColdStart}, ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))} isForceTopSession ${isForceTopSession}`);
    this.timeoutReportUE(EventType.LOCAL_DEVICE_PLAY, sessionId, { COLD_START: isColdStart });
    let getSessionController: SessionController | undefined =
      await this.commonInterface?.getCurrentController(sessionId);
    let play: AVSessionManager.AVControlCommand;
    if (isForceTopSession) {
      play = { command: 'play', parameter: sessionId };
    } else {
      play = { command: 'play' };
    }
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    if (SessionInfoProvider.isQuiting) {
      log.showInfo('is quiting, return ');
      return;
    }
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    await this.commonInterface?.sendControlCommand(sessionId, play).then(() => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callPlay cast');
        this.reportRader('callPlay', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.idle, BizState.start);
        this.isStartCastLink.set(true);
      }
    }).catch((errorCode : BusinessError.BusinessError) => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callPlay cast fail');
        this.reportRader('callPlay', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.fail, BizState.ending, { ERROR_CODE: errorCode.code });
      }
      let dfxParam : DfxParam = { PACKAGE_NAME: bundleName, REASON: errorCode.message, OPERATE_TYPE: 'PLAY',
        COLD_START: isColdStart, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }

  async callPause(sessionId: string) {
    log.showInfo(`callPause: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    this.timeoutReportUE(EventType.LOCAL_DEVICE_PAUSE, sessionId);
    let getSessionController: SessionController | undefined =
      await this.commonInterface?.getCurrentController(sessionId);
    let pause: AVSessionManager.AVControlCommand = { command: 'pause' };
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    if (SessionInfoProvider.isQuiting) {
      log.showInfo('is quiting, return ');
      return;
    }
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    await this.commonInterface?.sendControlCommand(sessionId, pause).then(() => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callPause cast');
        this.reportRader('callPause', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.idle, BizState.start);
        this.isStartCastLink.set(true);
      }
    }).catch((errorCode : BusinessError.BusinessError) => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callPause cast fail');
        this.reportRader('callPause', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.fail, BizState.ending, { ERROR_CODE: errorCode.code });
      }
      let dfxParam : DfxParam = { PACKAGE_NAME : bundleName, REASON: errorCode.message, OPERATE_TYPE: 'PAUSE',
        COLD_START: false, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }

  async callLyric(sessionId: string) {
    log.showInfo(`do not callLyric: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
  }

  /**
   * loopMode
   * @param sessionId
   * @param loopMode
   */
  async callLoop(sessionId: string, loopMode: number) {
    log.showInfo(`getLoopMode-- :sessionId: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}` );
    this.timeoutReportUE(EventType.LOCAL_DEVICE_LOOPMODE, sessionId, { CONTROL_MODE: loopMode });
    let getSessionController: SessionController | undefined =
      await this.commonInterface?.getCurrentController(sessionId);
    let loops: AVSessionManager.AVControlCommand = { command: 'setLoopMode', parameter: loopMode};
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    if (SessionInfoProvider.isQuiting) {
      log.showInfo('is quiting, return ');
      return;
    }
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    await this.commonInterface?.sendControlCommand(sessionId, loops).then(() => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callLoop cast');
        this.reportRader('callLoop', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.idle, BizState.start);
      }
    }).catch((errorCode : BusinessError.BusinessError) => {
      if (getSessionController?.type !== LOCAL) {
        // 雷达打点
        log.showInfo('callLoop cast fail');
        this.reportRader('callLoop', BizScene.sourceController, SourceController.sendControlCommand,
          StageResult.fail, BizState.ending, { ERROR_CODE: errorCode.code });
      }
      let dfxParam : DfxParam = { PACKAGE_NAME : bundleName, REASON: errorCode.message, OPERATE_TYPE: 'LOOPMODE',
        COLD_START: false, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }


  async startAimApp(sessionId: string) {
    let hasCall: boolean | undefined = AppStorage.get('hasCall');
    if (!sessionId && !hasCall) {
      return;
    }
    log.showInfo(`start aim app: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    let abilityName: string = this.sessionProvider?.abilityNameMap[sessionId];
    let sessionTag: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.sessionTag;
    let wantAgent: _WantAgent | undefined;
    let want: Want | undefined;
    try {
      let controller: AVSessionManager.AVSessionController | undefined;
      controller = this.sessionProvider?.avSessionControllerMap.get(sessionId);
      if (controller) {
        wantAgent = await controller.getLaunchAbility();
        want = wantAgent ? await WantAgent.getWant(wantAgent) : undefined;
      }
    } catch (err) {
      log.showInfo(`startAimApp get want err: ${err}`);
    }
    if (!want || bundleName !== want.bundleName) {
      want = {
        'bundleName': bundleName,
        'abilityName': abilityName
      };
      if (sessionTag === 'deliverMediaSession') {
        want.action = 'action.system.home';
        want.entities = ['entity.system.home'];
      }
    }
    // 本地电话
    if (!sessionId) {
      want = {
        bundleName: Constants.PHONE_CALL_SCENE.bundleName,
        abilityName: Constants.PHONE_CALL_SCENE.abilityName,
      }
    }
    if (!want.bundleName || !want.abilityName) {
      log.showInfo('start aim app with empty bundleName or abilityName , return ');
      this.reportUE(EventType.JUMP_APP, sessionId, 'INVALID_BUNDLENAME_ABILITYNAME', true);
      return;
    }
    try {
      this.startLaunchAbility(want, sessionId, wantAgent);
      log.showInfo(' startAimApp to quit');
    } catch (err) {
      log.warn(` startAimApp err : ${err}`);
    }
  }

  getDeviceModelType(): string {
    if (DeviceHelper.isPhone()) {
      return 'phone';
    } else if (DeviceHelper.isPC()) {
      return '2in1';
    } else if (DeviceHelper.isPad()) {
      return 'pad';
    } else if (DeviceHelper.DEVICE_TYPE === 'TV') {
      return 'TV';
    }
    return 'other';
  }

  getFold(): number {
    if (DeviceHelper.isPhone()) {
      if (DeviceHelper.isBarPhone()) {
        return -1;
      }
      return CommonUtils.isFoldExpanded() ? (CommonUtils.isThreeFoldProductInGState() ? 11 : 1) : 2;
    }
    return -1;
  }

  getScreenStatus(): number {
    if (DeviceHelper.getOrientation() === 1 || DeviceHelper.getOrientation() === 3 ) {
      return 1;
    } else {
      return 0;
    }
  }

  async startLaunchAbility(want: Want, sessionId: string, agent: _WantAgent | undefined): Promise<void> {
    let agentType: number = -1;
    if (agent) {
      try {
        agentType = await WantAgent.getOperationType(agent);
      } catch (err) {
        log.showError(`getOperationType err: ${err.message}`);
      }
    }
    log.showInfo(`startLaunchAbility with agentType = ${agentType}`);
    try {
      if (agentType >= 0) {
        log.showInfo(`startLaunchAbility with trigger`);
        WantAgent.trigger(agent, { code: 0 }, () => {
          log.showInfo(`startLaunchAbility with trigger success`);
          this.reportUE(EventType.JUMP_APP, sessionId, 'SUCCESS', true);
        });
      } else {
        this.context?.startAbility(want).then(async (data) => {
          log.showInfo('startAbility successful.');
          this.reportUE(EventType.JUMP_APP, sessionId, 'SUCCESS', true);
        }).catch((error : BusinessError.BusinessError) => {
          log.error('startAbility failed. Cause: ' + JSON.stringify(error));
          this.reportUE(EventType.JUMP_APP, sessionId, error.message, true);
          const dfxParam : DfxParam = { PACKAGE_NAME : want.bundleName, REASON: error.message, OPERATE_TYPE: 'JUMP_APP' };
          this.sessionProvider?.reportScenesHiEvent(EventType.JUMP_APP_FAIL, dfxParam, false);
        })
      }
      CommunicationUtil.prepareExitState = 'jump';
      CommunicationUtil.doRemoteEventNotify();
    } catch (err) {
      log.error(`startLaunchAbility err: ${err.message}`);
      this.reportUE(EventType.JUMP_APP, sessionId, err.message, true);
      const dfxParam : DfxParam = { PACKAGE_NAME : want.bundleName, REASON: err.message, OPERATE_TYPE: 'JUMP_APP' };
      this.sessionProvider?.reportScenesHiEvent(EventType.JUMP_APP_FAIL, dfxParam, false);
    }
  }
  /**
   * start app with sessionId if need and refresh meta info for new created session
   * @param sessionId 'default' / history session Id / new session Id
   * @param isLineControl is from session create event
   */
  async startDefaultAppNow(sessionId: string, isFromSessionCreate: boolean, shouldCallPlay: boolean) {
    const isColdStarting: boolean = globalStorage.getBooleanByKey('isColdStarting');
    log.showInfo(`start default app : ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}, ${isFromSessionCreate}, ${isColdStarting}, ${shouldCallPlay}`);
    if (!this.sessionProvider || sessionId === 'default') {
      log.showInfo('cold starting or default, return');
      return;
    }
    if (!isFromSessionCreate) {
      // cold start with empty entityId
      try {
        let bundle: string = this.sessionProvider?.bundleNameMap[sessionId];
        await AVSessionManager.startAVPlayback(bundle, '');
        globalStorage.setBooleanByKey('isColdStarting', true);
        if (this.enableDc) {
          messageChannel.sendMessage('syncGlobalStorage', { name: 'isColdStarting', value: true });
        }
        log.showInfo(` start default app startAVPlayback for ${bundle}`);
        return;
      } catch (err) {
        log.error('start default app startAVPlayback fail :', err);
      }
    }
    try {
      let defaultController: AVSessionManager.AVSessionController | undefined =
        this.sessionProvider?.avSessionControllerMap.get(sessionId);
      if (!defaultController) {
        log.error(` start default app controller get fail`);
        globalStorage.setBooleanByKey('isColdStarting', false);
        if (this.enableDc) {
          messageChannel.sendMessage('syncGlobalStorage', { name: 'isColdStarting', value: false });
        }
        return;
      }
      log.showInfo(`get default controller success, new sessionId: ${defaultController.sessionId?.length < 10 ? '' :
        (defaultController.sessionId?.substr(0, 5) + '**' +
        defaultController.sessionId?.substr(defaultController.sessionId?.length - 5))}`);
      const newSessionId: string = defaultController.sessionId;
      const sessionDescriptor : AVSessionManager.AVSessionDescriptor =
        this.sessionProvider?.avSessionDescriptorMap[newSessionId];
      // refresh app icon
      if (sessionDescriptor) {
        this.refreshAppIcon(sessionDescriptor.sessionId);
      }
      // refresh all media info
      await this.refreshMediaInfo(defaultController);
    } catch (err) {
      log.showInfo(`start default app err : ${err}`);
    }
    globalStorage.setBooleanByKey('isColdStarting', false);
    CommunicationUtil.doLocalEventNotify('coldStartDone', 'done');
    if (this.enableDc) {
      messageChannel.sendMessage('syncGlobalStorage', { name: 'isColdStarting', value: false });
      messageChannel.sendMessage('syncLocalNotify', { name: 'coldStartDone', value: 'done' });
    }
    log.showInfo(' start default app done ');
  }

  /**
   * 启动歌单
   * @param albInfo
   * @param albumInfoLisData
   */
  async startAlbum(albInfo: AVQueueInfo, albumInfoLisData: AVQueueInfo[]) {
    if (!albInfo.bundleName || !albInfo.avQueueId) {
      return;
    }
    await AVSessionManager.startAVPlayback(albInfo.bundleName, albInfo.avQueueId).then(() => {
      log.showInfo(`hisAVQueue success to startavplayback`);
    }).catch((err: BusinessError.BusinessError) => {
      this.reportStartMediaPlayBack(albInfo, -1);
      AppStorage.setOrCreate('clickAVQueueTime', 0);
      AppStorage.setOrCreate('isRefreshData', true);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', { name: 'clickAVQueueTime', value: 0 });
        messageChannel.sendMessage('syncAppStorage', { name: 'isRefreshData', value: true });
      }
      log.showInfo(`hisAVQueue fail to startavplayback--result: ${JSON.stringify(err)}`);
    })
  }

  async startExpandAlbum(albInfo: AVQueueInfo, albumInfoList: AVQueueInfo[]) {
    AppStorage.setOrCreate('isStartAVPlaybackSuccess', true);
    if (this.enableDc) {
      messageChannel.sendMessage('syncAppStorage', { name: 'isStartAVPlaybackSuccess', value: true });
    }
    let clickAVQueueTime = new Date().getTime();
    await AVSessionManager.startAVPlayback(albInfo?.bundleName, albInfo?.avQueueId).then(() => {
      log.showInfo(`hisAVQueue success to startavplayback`);
      this.reportStartMediaPlayBack(albInfo, new Date().getTime() - clickAVQueueTime);
    }).catch((err: BusinessError.BusinessError) => {
      this.reportStartMediaPlayBack(albInfo, -1);
      log.showInfo(`hisAVQueue fail to startavplayback--result: ${JSON.stringify(err)}`);
      AppStorage.setOrCreate('isStartAVPlaybackSuccess', false);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', { name: 'isStartAVPlaybackSuccess', value: false });
      }
    })
  }

  /**
   * 播放歌单
   * @param albInfo
   */
  replayAlbum(albInfo: AVQueueInfo, oldAlbInfo: AVQueueInfo) {
    let clickAVQueueTime = new Date().getTime();
    AVSessionManager.startAVPlayback(albInfo?.bundleName, albInfo?.avQueueId).then(() => {
      log.showInfo(`hisAVQueue success to startavplayback,replayAlInfo`);
      this.reportStartMediaPlayBack(albInfo, new Date().getTime() - clickAVQueueTime);
    }).catch((err: BusinessError.BusinessError) => {
      this.reportStartMediaPlayBack(oldAlbInfo, -1);
      log.error(`hisAVQueue fail to startavplayback,replayAlInfo--result: ${JSON.stringify(err)}`);
    })
  }

  playAvQueue(bundleName: string, avQueueId: string) {
    AVSessionManager.startAVPlayback(bundleName, avQueueId).then(() => {
      log.showInfo(`hisAVQueue success to startavplayback,replayAlInfo`);
    }).catch((err: BusinessError.BusinessError) => {
      log.error(`hisAVQueue fail to startavplayback,replayAlInfo--result: ${JSON.stringify(err)}`);
    })
  }

  releaseInputMediaVolumeCallback() {
    this.inputMediaVolumeCallback = () => {};
  }

  releaseTaskDoubt(sessionId: string) {
    log.showInfo(`task release media info: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    if (sessionId === 'CLEAR_PROVIDER') {
      // 清空引用，释放内存
      this.volumeManager?.release();
      this.commonInterface?.release();
      this.volumeManager = undefined;
      this.commonInterface = undefined;
      this.sessionProvider = undefined;
      this.inputMediaVolumeCallback = () => {};
      this.inputCallVolumeCallback = () => {};
      MediaInfoProvider.providerSelf = undefined;
      SessionInfoProvider.off('sessionChanged', this.getSessionChangedCallback());
      SessionInfoProvider.off('controllerChanged', this.getControllerChangedCallback());
      SessionInfoProvider.off('topSessionChangeHis', this.getTopSessionChangedCallback());
      SessionInfoProvider.off('sessionDestroy', this.getSessionDestroyCallback());
      if (this.enableDc) {
        messageChannel.offMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, this.callByWorker); // 监听子线程消息
      }
      return;
    }
    if (this.metaDataMapLink) {
      let tempMetaDataMap: Map<string, AVSessionManager.AVMetadata> = this.metaDataMapLink.get();
      tempMetaDataMap[sessionId] = undefined;
      this.metaDataMapLink.set(tempMetaDataMap);
    }
    if (this.imageRatioMapLink) {
      let tempImageRatioMap = this.imageRatioMapLink.get();
      tempImageRatioMap[sessionId] = undefined;
      this.imageRatioMapLink.set(tempImageRatioMap);
    }
    if (this.lastTitleMapLink) {
      let lastTitleMap:Map<string, string> = this.lastTitleMapLink;
      lastTitleMap[sessionId] = undefined;
      this.lastTitleMapLink = lastTitleMap;
    }
    if (this.appIconMapLink) {
      let tempAppIconMap: Map<string, image.PixelMap> = this.appIconMapLink.get()
      tempAppIconMap[sessionId] = undefined;
      this.appIconMapLink.set(tempAppIconMap);
    }
    if (this.playStateMapLink) {
      let tempPlayStateMap: Map<string, AVSessionManager.AVPlaybackState> = this.playStateMapLink.get();
      tempPlayStateMap[sessionId] = undefined;
      this.playStateMapLink.set(tempPlayStateMap);
    }
    if (this.commandEnableMapLink) {
      let tempCommandEnableMap: Map<string, Array<AVSessionManager.AVControlCommandType>> =
        this.commandEnableMapLink.get();
      tempCommandEnableMap[sessionId] = undefined;
      this.commandEnableMapLink.set(tempCommandEnableMap);
    }
    if (this.enableDc) {
      // 通知子线程
      messageChannel.sendMessage('syncSubData', { sessionId, needRemove: true});
    }
    log.showInfo(' task release done ')
  }


  /**
   * 上报设备日志
   * @param sessionId
   * @param startTime
   */
  reportShowDeviceList(sessionId: string, startTime: number, isShowSwitch: number): void {
    if (!this.sessionProvider) {
      return;
    }
    let avType: AVSessionManager.AVSessionType | string =
      this.sessionProvider.avSessionDescriptorMap[sessionId]?.type || '';
    log.showInfo(`reportShowDeviceList-type = ${avType}`);
    let bundleName: string = this.sessionProvider.bundleNameMap[sessionId] || '';
    let dfxParam: DfxParam = {
      TIME_COST: new Date().getTime() - startTime,
      APP_TYPE: avType.toString(),
      PACKAGE_NAME: bundleName,
      PNAMEID: this.pInfoName,
      PVERSIONID: this.pInfoVersion,
      TIME: new Date().getTime(),
      CONTROLINTERFACE: isShowSwitch,
      SCREENSTATUS: this.getScreenStatus(),
      DEVICEMODELTYPE: this.getDeviceModelType(),
      SCREENFOLDEDSTATUS: this.getFold(),
      PICKER_STYLE: 'NONE'
    };
    this.sessionProvider.reportScenesHiEvent(EventType.SHOW_DEVICE_LIST, dfxParam, true);
  }

  /**
   * 监听castSession
   * @param hasCast 是否存在castSession双卡（本地与投播卡片）
   * @param sessionId
   */
  setCastSessionListener(hasCast: boolean, sessionId: string | undefined) {
    this.castSessionController?.off('outputDeviceChange', this.doOutputDeviceChange);
    this.castSessionController = undefined;
    if (hasCast && sessionId && this.sessionProvider) {
      this.castSessionController = this.sessionProvider.avSessionControllerMap.get(sessionId);
      this.castSessionController?.on('outputDeviceChange', this.doOutputDeviceChange);
    }
  }

  /**
   * 清除castSession监听
   */
  clearCastSessionListener() {
    this.castSessionController?.off('outputDeviceChange', this.doOutputDeviceChange);
    this.castSessionController = undefined;
  }

  private doOutputDeviceChange = (connectState: AVSessionManager.ConnectionState | number,
    device: AVSessionManager.OutputDeviceInfo) => {
    CommunicationUtil.doLocalEventNotify('castSessionDeviceChange', connectState);
    if (this.enableDc) {
      messageChannel.sendMessage('syncLocalNotify', {name: 'castSessionDeviceChange', value: connectState});
    }
  }

  /**
   * 是否为视频应用
   * @param sessionId
   */
  getIsVideo(sessionId: string): boolean {
    let isVideo: boolean | undefined = this.sessionProvider?.sessionTypeMap[sessionId];
    return !!isVideo;
  }

  /**
   * 歌单显示上报
   * @param showState
   * @param operatingMode
   * @param isHistoryAVQueue
   */
  reportAVQueueShowState(showState: number, operatingMode: number, isHistoryAVQueue: boolean) {
    let dfxParam: DfxParam = {
      PNAMEID: this.pInfoName,
      PVERSIONID: this.pInfoVersion,
      SHOW_STATE: showState,
      IS_HISTORY_AVQUEUE: isHistoryAVQueue,
      OPERATING_MODE: operatingMode
    };
    this.sessionProvider?.reportScenesHiEvent(EventType.AVQUEUE_SHOW_STATE, dfxParam, true);
  }
}

type playbackStateChangeType = (state: AVSessionManager.AVPlaybackState) => void

export class CommonInterface {
  private sessionProvider: SessionInfoProvider | undefined;
  private volumeManager: VolumeManager | undefined;
  private startPosition: number = -1;
  private startPositionTime: number = -1;
  private stateSessionId: string = '';
  private playStateCallbackMap:Map<string, playbackStateChangeType | undefined> = new Map();
  private sessionControllerMap:Map<string, AVSessionManager.AVSessionController | undefined> = new Map();
  private metadataCallbackMap: Map<string, MetadataChangeCallback> = new Map();
  private validCommandCallbackMap: Map<string, ValidCommandChangeCallback> = new Map();
  private isConnectingLink: AbstractProperty<boolean> = AppStorage.setAndRef('isConnectingLink', false);

  init(provider: SessionInfoProvider, volumeManager: VolumeManager | undefined) {
    log.showInfo('CommonInterface init');
    this.sessionProvider = provider;
    this.volumeManager = volumeManager;
  }

  release() {
    log.showInfo('CommonInterface release');
    this.releaseCallback();
    this.sessionProvider = undefined;
    this.volumeManager = undefined;
  }

  releaseCallback() {
    this.playStateCallbackMap.forEach((playbackStateCallback: playbackStateChangeType | undefined,
      sessionId:string) => {
      let sessionController: AVSessionManager.AVSessionController | undefined =
        this.sessionControllerMap.get(sessionId);
      if (sessionController) {
        try {
          sessionController.off('playbackStateChange', playbackStateCallback);
        } catch (err) {
          log.error('playbackStateChange release error, ', err)
        }
      }
    })
    this.metadataCallbackMap.forEach((metadataCallback: MetadataChangeCallback) => {
      MediaEventManager.unRegisterEventListener(MediaEventType.METADATA_CHANGE, metadataCallback);
    })
    this.validCommandCallbackMap.forEach((validCommandCallback: ValidCommandChangeCallback) => {
      MediaEventManager.unRegisterEventListener(MediaEventType.VALID_COMMAND_CHANGE, validCommandCallback);
    })
    this.playStateCallbackMap.clear();
    this.sessionControllerMap.clear();
    this.metadataCallbackMap.clear();
    this.validCommandCallbackMap.clear();
  }

  releaseCallbackBySession(sessionId: string) {
    let metadataCallback: MetadataChangeCallback | undefined = this.metadataCallbackMap.get(sessionId);
    if (metadataCallback != undefined) {
      this.metadataCallbackMap.delete(sessionId);
      MediaEventManager.unRegisterEventListener(MediaEventType.METADATA_CHANGE, metadataCallback);
    }
    let validCommandCallback: ValidCommandChangeCallback | undefined = this.validCommandCallbackMap.get(sessionId);
    if (validCommandCallback != undefined) {
      this.validCommandCallbackMap.delete(sessionId);
      MediaEventManager.unRegisterEventListener(MediaEventType.VALID_COMMAND_CHANGE, validCommandCallback);
    }
    if (this.playStateCallbackMap.get(sessionId)) {
      this.playStateCallbackMap.delete(sessionId);
    }
    this.sessionProvider?.avSessionControllerMap.get(sessionId)?.off('playbackStateChange');
  }

  public async getCurrentController(sessionId: string) : Promise<SessionController> {
    if (!this.sessionProvider) {
      return { type: '' };
    }
    let isCastSession: boolean = await this.sessionProvider?.checkIsCastSession(sessionId) || false;
    const isCastRemote = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.sessionTag === 'RemoteCast';
    log.showInfo(`isCastSession:${isCastSession}, isCastRemote:${isCastRemote}`)
    return {
      type: 'local',
      controller: this.sessionProvider.avSessionControllerMap.get(sessionId),
    };
  }

  public async getValidCommands(sessionId: string) : Promise<Array<AVSessionManager.AVControlCommandType>> {
    const sessionController = await this.getCurrentController(sessionId);
    if (!sessionController.controller) {
      log.error(`fail to get valid command: no controller found`);
      return Promise.reject<never>('getValidCommands controller is null');
    }
    log.showInfo(`try get valid command: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}, ${sessionController.type}`);
    return (sessionController.controller as AVSessionManager.AVSessionController).getValidCommands();
  }

  public async getAVMetadata(sessionId: string) : Promise<AVSessionManager.AVMetadata | undefined> {
    const sessionController = await this.getCurrentController(sessionId);
    if (!sessionController.controller) {
      log.error(`fail to get av meta data: no controller found`);
      return Promise.reject<never>('getAVMetadata controller is null');
    }
    log.showInfo(`try get av meta data: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}, ${sessionController.type}`);
    if (sessionController.type === 'local') {
      return (sessionController.controller as AVSessionManager.AVSessionController).getAVMetadata();
    } else {
      return undefined
    }
  }

  onMetadataChange(sessionController: AVSessionManager.AVSessionController, isUpdate: boolean,
                   callback : (state : AVSessionManager.AVMetadata | null, type : string) => void) {
    const sessionId = sessionController.sessionId;
    if (!isUpdate && !this.metadataCallbackMap.has(sessionId)) {
      let metadataCallback = new MetadataChangeCallback((event: MetadataChangeEvent) => {
        let avMetadata: AVSessionManager.AVMetadata = {assetId: event.metadata.assetId};
        for (let key of event.updatedKeys) {
          avMetadata[key] = event.metadata[key];
        }
        callback(avMetadata, 'locale');
      }, sessionId);
      this.metadataCallbackMap.set(sessionId, metadataCallback);
      MediaEventManager.registerEventListener(MediaEventType.METADATA_CHANGE, metadataCallback);
    }
    if (!this.sessionProvider) {
      return;
    }
  }

  async onValidCommandChange(sessionController: AVSessionManager.AVSessionController, isUpdate: boolean,
    callback : (commands : Array<AVSessionManager.AVControlCommandType> |
    Array<AVSessionManager.AVCastControlCommandType> | null) => Promise<void>): Promise<void> {
    const sessionId = sessionController.sessionId;
    if (!isUpdate && !this.validCommandCallbackMap.has(sessionId)) {
      let validCommandCallback = new ValidCommandChangeCallback((event: ValidCommandChangeEvent) => {
        let enableCommand : AVSessionManager.AVControlCommandType[] = [];
        let enableCommandsArray: AVSessionManager.AVControlCommandType[] = event.commands;
        let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
        log.showInfo(` validCommandChange check bundle ${bundleName}`);
        for (let i = 0; i < enableCommandsArray.length; i++) {
          log.debug(' validCommandChange get validCommand : ' + enableCommandsArray[i]);
          enableCommand.push(enableCommandsArray[i]);
        }
        log.showInfo(' validCommandChange callback state done ');
      }, sessionId);
      this.validCommandCallbackMap.set(sessionId, validCommandCallback);
      MediaEventManager.registerEventListener(MediaEventType.VALID_COMMAND_CHANGE, validCommandCallback);
    }
  }

  private async parseCastMetaData(description: AVSessionManager.AVMediaDescription | undefined, sessionId: string) {
    log.showInfo(`start parse cast meta data: ${JSON.stringify(description)}`);
    if (!description) {
      log.showInfo('cast meta data is empty');
      return undefined;
    }
    let metadata: AVSessionManager.AVMetadata = {
      assetId: description.assetId,
      title: description.title,
      artist: description.artist,
      mediaImage: description.mediaImage || description.albumCoverUri,
      duration: description.duration,
    };
    if (description.startPosition) {
      this.startPosition = description.startPosition;
      this.startPositionTime = new Date().getTime();
    }
    const avController = this.sessionProvider?.avSessionControllerMap.get(sessionId);
    if (!avController) {
      log.showInfo('av controller is null');
      return metadata;
    }
    const localData : AVSessionManager.AVMetadata = await avController.getAVMetadata();
    if (localData?.skipIntervals !== undefined) {
      log.showInfo(`use skipIntervals from local: ${localData.skipIntervals}`);
      metadata.skipIntervals = localData.skipIntervals;
    }
    if (localData.assetId !== metadata.assetId) {
      log.error('assetId not same');
      log.showInfo(`${CommonUtils.getMaskStr(localData.assetId)} !== ${CommonUtils.getMaskStr(metadata.assetId)}`);
      return metadata;
    }
    if (!metadata.mediaImage && localData.mediaImage) {
      log.showInfo('use mediaImage from local');
      metadata.mediaImage = localData.mediaImage;
    }
    if (localData.displayTags !== undefined) {
      log.showInfo(`use displayTags from local: ${localData.displayTags}`);
      metadata.displayTags = localData.displayTags;
    }
    if (localData.duration !== undefined) {
      log.showInfo(`do not use duration from local when in cast: ${description.duration} vs ${localData.duration}`);
    }
    if (localData.filter !== undefined) {
      log.showInfo(`use filter from local: ${localData.filter}`);
      metadata.filter = localData.filter;
    }
    if (localData.avQueueId !== undefined) {
      metadata.avQueueId = localData.avQueueId;
    }
    return metadata;
  }

  /**
   * send control command depend to current controller type
   */
  public async sendControlCommand(sessionId: string, command: Object) {
    if (!this.sessionProvider) {
      return;
    }
    log.showInfo(`sendControlCommand sessionId = ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`)
    const isCastSession = await this.sessionProvider?.checkIsCastSession(sessionId);
    const isCastRemote = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.sessionTag === 'RemoteCast';
    log.showInfo(`isCastSession:${isCastSession}, isCastRemote:${isCastRemote}`)
    let avSessionController = this.sessionProvider?.avSessionControllerMap.get(sessionId);
    await avSessionController?.sendControlCommand(command as AVSessionManager.AVControlCommand)
      .then(() => {
        log.showInfo(`av send common control command suc: ${JSON.stringify(command)}`);
      });
  }

  async getAVPlaybackState(sessionId: string): Promise<AVState> {
    const sessionController : SessionController = await this.getCurrentController(sessionId);
    if (!sessionController.controller) {
      log.error(`fail to get av playback state: no controller found`);
      return Promise.reject('getAVPlaybackState controller is null');
    }
    log.showInfo(`try get av playback state: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}, ${sessionController.type}`);
    return sessionController.controller.getAVPlaybackState()
      .then((avPlaybackState : AVSessionManager.AVPlaybackState) => {
        log.showInfo(`get av playback state from ${sessionController.type} suc: ${JSON.stringify(avPlaybackState)}`);
        if (sessionController.type === 'cast' && avPlaybackState?.position) {
          if (avPlaybackState.position.elapsedTime >= 0) {
            avPlaybackState.position.elapsedTime = avPlaybackState.position.elapsedTime;
            avPlaybackState.position.updateTime = new Date().getTime();
          } else {
            avPlaybackState.position.elapsedTime = this.startPosition;
            avPlaybackState.position.updateTime = this.startPositionTime;
          }
          this.startPosition = -1;
          this.startPositionTime = -1;
        }
        const avBackInfo : AVState = {type : sessionController.type, value: avPlaybackState };
        return avBackInfo;
      });
  }

  onPlaybackStateChanged(sessionController: AVSessionManager.AVSessionController, isUpdate: boolean,
                         callback : (state : AVSessionManager.AVPlaybackState, locale : string) => void) {
    if (!isUpdate) {
      if (!this.playStateCallbackMap.get(sessionController.sessionId)) {
        log.showInfo(`set onPlaybackStateChanged`);
        let playStateCallback = (state: AVSessionManager.AVPlaybackState) => {
          log.showInfo(`on local playbackStateChange state:  ${JSON.stringify(state)}`);
          callback(state, 'locale');
        }
        sessionController.on('playbackStateChange', 'all', playStateCallback);
        this.playStateCallbackMap.set(sessionController.sessionId, playStateCallback);
        this.sessionControllerMap.set(sessionController.sessionId, sessionController);
      }
    }
    const sessionId = sessionController.sessionId;
    this.stateSessionId = sessionId;
  }

  setIsConnecting(isConnecting: boolean) {
    this.isConnectingLink.set(isConnecting);
  }

  private castPlayStateCallback = (state: AVSessionManager.AVPlaybackState) => {
    log.showInfo(`on cast playbackStateChange state: ${JSON.stringify(state)}`);
    let curDeviceSelect: LocalDeviceInfo | undefined = AppStorage.get('CurDeviceSelect');
    let protocol = 'LOCAL';
    let bundleName: string = this.sessionProvider?.bundleNameMap[this.stateSessionId];
    log.showInfo(`ending: ${AppStorage.get('isStartCast')}, ${AppStorage.get('isConnectCast')}`);
    if (!!state.state && AppStorage.get('isConnectCast')) { // sink端状态返回+设备连接成功
      // sink端资源播放 雷达打点
      log.showInfo(`playbackStateChange cast sink `);
      MediaInfoProvider.getInstance()?.reportRader('castPlayStateCallback', BizScene.startCast, StartCAST.sinkPlay,
        StageResult.sussess, BizState.ending, { PROTOCOL: protocol, APP_CALLER: bundleName });
      AppStorage.set('isConnectCast', false);
      this.isConnectingLink.set(false);
    } else if (!!AppStorage.get('isStartCast')) {
      // source端都播控制
      log.showInfo(`playStateCallback radar source`);
      MediaInfoProvider.getInstance()?.reportRader('castPlayStateCallback', BizScene.sourceController,
        SourceController.sourceReceiveCallback, StageResult.sussess, BizState.ending, { APP_CALLER: bundleName });
      AppStorage.set('isStartCast', false);
    }
    MediaInfoProvider.getInstance()?.dealPlaybackStateChanged(state, 'cast', this.stateSessionId);
  }

  async getCurrentVolume(sessionId: string) : Promise<VolumeInfo | null> {
    const sessionController : SessionController = await this.getCurrentController(sessionId);
    log.showInfo(`try get volume: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}, ${sessionController.type}`);
    const volumeInfo : VolumeInfo = {type : sessionController.type, value : 0}
    if (!this.volumeManager) {
      log.error('getCurrentVolume volumeManager is null');
      return null;
    }
    if (sessionController.type === 'local') {
      volumeInfo.value = await this.volumeManager.getCurrentVolume();
    } else {
      if (sessionController.controller) {
        let avPlaybackState: AVSessionManager.AVPlaybackState =
          await sessionController.controller.getAVPlaybackState();
        if (avPlaybackState.volume) {
          const castVolume: number = avPlaybackState.volume;
          volumeInfo.value = Math.round(Constants.VOLUME_SLIDER_MAX * castVolume / Constants.CAST_VOLUME_MAX);
        }
      }
    }
    return volumeInfo;
  }

  async setVolume(volume: number, mode: number, sessionId?: string) {
    const controller : SessionController | undefined = sessionId === undefined ?
      undefined : await this.getCurrentController(sessionId);
    const type: SetVolumeType = controller === undefined ? SetVolumeType.CALL :
      (controller?.type !== 'local' ? SetVolumeType.CAST : SetVolumeType.AUDIO);
    log.showInfo(`try set volume: ${volume}, ${mode}, ${type}`);
    this.volumeManager?.callVolumeChange(volume, mode, type, sessionId);
  }

  /**
   * 设置投播音量
   * @param sessionId
   * @param actionType
   */
  async setCastVolume(sessionId: string, actionType: InputVolumeAction) {
    const controller : SessionController = await this.getCurrentController(sessionId);
    log.showInfo(`try set cast volume: ${controller.type}`);
    if (this.sessionProvider?.checkIsPcmCast(sessionId)) {
      this.volumeManager?.setPcmCastVolume(sessionId, actionType);
    }
    this.volumeManager?.callCastVolumeChange(sessionId, actionType);
  }
}
