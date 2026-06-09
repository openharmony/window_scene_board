/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import bundle from '@ohos.bundle';
import { LogDomain, LogHelper, DomainName } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { TraceUtil } from '@ohos/basicutils/src/main/ets/utils/TraceUtil';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import {
  DropDownEvent,
  TargetPanel,
  ScreenLockEvent,
  OobeActivatedEvent,
} from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { sEventManager, unsubscribe } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import { obtainLocalEvent } from '@ohos/frameworkwrapper/src/main/ets/utils/EventUtil';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/plugin/PluginConstants';
import { StartAbilityUtil } from '@ohos/windowscene/src/main/ets/startAbility/StartAbilityUtil';
import { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import CommunicationUtil from '../Util/CommunicationUtil';
import SessionInfoProvider from './SessionInfoProvider';
import AVSessionManager from '@ohos.multimedia.avsession';
import image from '@ohos.multimedia.image';
import { ControlCenterState } from '@ohos/controlcentercommon/src/main/ets/common/ControlCenterConstants';
import Want from '@ohos.app.ability.Want';
import WantAgent, { WantAgent as _WantAgent} from '@ohos.app.ability.wantAgent';
import { BusinessError } from '@ohos.base';
import power from '@ohos.power';
import common from '@ohos.app.ability.common';
import notificationSubscribe from '@ohos.notificationSubscribe';
import audio from '@ohos.multimedia.audio';
import { LocalEventCallback } from '../Util/LocalEventCallBack';
import Constants, {
  CurOutputDevTS,
  ShowingBundleTS,
  DeviceSource,
  AVCastPickerDeviceIconName,
  LocalDeviceInfo,
  SyncDeviceInfo,
  WorkerMsgParameter,
  CarInfo,
  SyncGlobalStorageInfo
} from '../Util/Constants';
import { systemParameterEnhance, systemTimer } from '@kit.BasicServicesKit';
import { BizScene, BizState, EventType, StageResult, StartCAST, TriggerMode } from '../Util/HiSysEvent';
import { DfxParam, SongInfo, RadarParam } from '../Util/CommonInterface';
import { globalStorage } from '../Util/GlobalStorage';
import bundleManager from '@ohos.bundle.bundleManager';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import {
  ImmersiveSysEventUtils,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/common/ImmersiveSysEventUtil';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { ObjectCopyUtil } from '@ohos/componenthelper/src/main/ets/utils/ObjectCopyUtil';
import { JSON } from '@kit.ArkTS';
import ImageDownloaderUtils from '../Util/ImageDownloaderUtils';
import CommonUtils from '../Util/CommonUtils';
import { combineObject, debounce } from '../Util/Tool';
import { MediaEventCallback, MetadataChangeCallback, ValidCommandChangeCallback } from '../EventBus/MediaEventCallback';
import { MediaEventManager, MediaEventType } from '../EventBus/MediaEventManager';
import { MetadataChangeEvent, ValidCommandChangeEvent } from '../EventBus/MediaEvent';
// import collaborationServiceManager from '@hms.collaboration.collaborationServiceManager'
import MediaInfoProvider from './MediaInfoProvider';
import { CastDeviceControl } from './CastDeviceControl';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import sControlCenterScreenLockController from '@ohos/controlcentercommon/src/main/ets/base/CommonScreenLockController';
import CommonEventManager from '@ohos.commonEventManager';
import promptAction from '@ohos.promptAction';
import { PixelMapUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CollaborationCallBack, CollaborationRegisterManager } from './CollaborationRegisterManager';

const TAG = 'CardMediaController_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const RECENTLY_PLAYED: string = '最近播放';
const JUMP_MEDIA: string = 'JumpInMediaCenter';
const REMOVE_NOTIFICATION_TIME: number = 10 * 60 * 1000;

interface SubInfoTS {
  events: string[]
};

interface GetCurrentControllerTS {
  type: string;
  controller: AVSessionManager.AVSessionController | undefined | null;
};

interface MetadataTS {
  assetId: string;
  title?: string;
  subtitle?: string;
  artist?: string;
  mediaImage?: image.PixelMap | string;
  skipIntervals?: number;
  duration?: number | undefined;
  lyric?: string | undefined;
  displayTags?: number | undefined;
  avQueueId?: string | undefined;
}

interface ExtraData {
  mediaType?: AVSessionManager.AVSessionType,
  validCommands?: Array<AVSessionManager.AVCastControlCommandType> | Array<AVSessionManager.AVControlCommandType>
}

export interface ShowingMesTS {
  loopMode?: string | number | undefined;
  controlMediaTitle?: string | boolean | undefined;
  musicTitle?: string | boolean | undefined;
  musicAuthor?: string | boolean | undefined;
  musicPic?: boolean | string | image.PixelMap | undefined;
  mediaPlayerIcon?: boolean | string | image.PixelMap | undefined;
  playState?: number | undefined;
  hasMedia?: boolean | undefined;
  validCommands?: Array<string> | undefined;
  skipIntervals?: number | undefined;
  mediaType?: AVSessionManager.AVSessionType | undefined;
  appName?: string | boolean;
  duration?: number | undefined;
  position?: AVSessionManager.PlaybackPosition | undefined;
  speed?: number | undefined;
  lyric?: string | undefined;
  musicAssetId?: string | number | undefined;
  isFavor?: boolean | undefined;
  displayTags?: number | undefined;
  isAVSessionDestroy?: boolean;
  avQueueId?: string | undefined;
  forceUpdate?: boolean;
  isChangeApp?: boolean;
  isChangeSong?: boolean;
  isCastController?: boolean;
}

interface CurOutputDev {
  deviceType?: audio.DeviceType;
  deviceId?: number;
  deviceAddress?: string;
  networkId?: string;
}

type playbackStateChangeType = (state: AVSessionManager.AVPlaybackState) => void

export interface MediaDataTS {
  hasMedia?: boolean;
  mediaImg?: string | PixelMap;
  appIcon?: string | PixelMap;
  mediaTitle?: string | boolean;
  mediaArtist?: string | boolean;
  playState?: boolean;
  skipIntervals?: number;
  mediaType?: AVSessionManager.AVSessionType;
  curAppName?: string | boolean;
  isLandscape?: boolean;
  isShowRewind?: boolean;
  isShowFastforward?: boolean;
  isShowPlayPrevious?: boolean;
  isShowPlayNext?: boolean;
  isShowPlay?: boolean;
  imagesWidth?: number;
  imagesHeight?: number;
  imagesX?: number;
  imagesY?: number;
  mediaCardX?: Length;
  mediaCardY?: Length;
  curOutputDev?: CurOutputDevTS;
  curRemoteOutputDev?: number;
}

export class CardMediaController {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private showingFormId: string | undefined = undefined;
  private showingMediaId: string | undefined = undefined;
  private showingAssetId: string | undefined = undefined;
  private showingController:
    AVSessionManager.AVSessionController | AVSessionManager.AVCastController | undefined = undefined;
  private showingAppIcon: image.PixelMap | string | boolean | undefined = undefined;
  private showingPlayState: AVSessionManager.AVPlaybackState | undefined = undefined;
  private sessionProvider: SessionInfoProvider | undefined = undefined;
  private commonInterface: CommonInterface | undefined = undefined;
  private isShowingListened: boolean = false; // 启动时是否已监听
  private lastAppName: string | boolean = '';
  private lastMusicAssetId: string | number = '';
  private lastPixelMapId: string | number | undefined = undefined;
  private lastLyric: string | undefined = undefined;

  private OPERATE_MIN_INTERVAL: number = 200;
  private preOrNextOperateTimeStamp: number = new Date().getTime();
  private unsubscribe?: unsubscribe = undefined;
  private dropDownTimeStamp: number = new Date().getTime();
  private DROPDOWN_CALLBACK_INTERVAL: number = 300;
  private appName: string | boolean = false;
  private static mediaDisplayTagsLink:AbstractProperty< number | null> | undefined = undefined
  private static mediaLoopModeLink: AbstractProperty<string | number | null> | undefined = undefined
  private static mediaTitleLink: AbstractProperty<string | boolean | null> | undefined = undefined;
  private static songInfoLink: AbstractProperty<SongInfo> | undefined = undefined;
  private static controlMediaTitleLink: AbstractProperty<string | boolean | null> | undefined = undefined;
  private static mediaArtistLink: AbstractProperty<string | boolean | null> | undefined = undefined;
  private static mediaImgShowLink: AbstractProperty<boolean | null> | undefined = undefined;
  private static appIconShowLink: AbstractProperty<boolean | null> | undefined = undefined;
  private static mediaIconLink: AbstractProperty<boolean | string | image.PixelMap | null> | undefined = undefined;
  private static mediaImgLink: AbstractProperty<boolean | string | image.PixelMap | null> | undefined = undefined;
  private static mediaPlayStateLink: AbstractProperty<number | null> | undefined = undefined;
  private static mediaEnableLink: AbstractProperty<boolean | null> | undefined = undefined;
  private static mediaValidCommandsLink: AbstractProperty<Array<string>> | undefined = undefined;
  private static mediaSkipIntervalsLink: AbstractProperty<number | null> | undefined = undefined;
  private static mediaTypeLink: AbstractProperty<AVSessionManager.AVSessionType | null> | undefined = undefined;
  private static appNameLink: AbstractProperty<string | boolean | null> | undefined = undefined;
  private static isVideoLink: AbstractProperty<boolean | null> | undefined = undefined;
  private static mediaSpeedLink: AbstractProperty<string | number | null> | undefined = undefined;
  private static hasLyricLink: AbstractProperty<boolean> | undefined = undefined;
  private static isChangeSongLink: AbstractProperty<boolean> | undefined = undefined;
  private static isChangeAppLink: AbstractProperty<boolean> | undefined = undefined;
  private static lastNotifyId: string = '';
  private removeNotificationTimer: number | undefined = undefined;
  private showingMesHistoryTitle: string | boolean | undefined;
  private isShowingMesHistory: boolean = false;
  private deviceNotificationCallback: LocalEventCallback | undefined = undefined;
  private controllerChangeCallback: LocalEventCallback | undefined = undefined;
  private sessionChangeCallback: LocalEventCallback | undefined = undefined;
  private topSessionChangeCallback: LocalEventCallback | undefined = undefined;
  private sessionDestroyCallback: LocalEventCallback | undefined = undefined;
  private static controller: CardMediaController | undefined = undefined;
  public static showingWant: Want | undefined = undefined;
  private context: common.UIExtensionContext | common.ServiceExtensionContext | undefined = GlobalContext.getContext();
  private static avQueueIdLink: AbstractProperty<string | null> | undefined = undefined;
  private static playbackPositionLink: AbstractProperty<AVSessionManager.PlaybackPosition> | undefined = undefined;
  private static isFavorLink: AbstractProperty<boolean> | undefined = undefined;
  private static durationLink: AbstractProperty<number | null> | undefined = undefined;

  // 打点
  private pInfoName: string = '';
  private pInfoVersion: string = '';
  private controlEventMap: Map<EventType, boolean> = new Map();
  private controlEventStartTime: Map<EventType, number> = new Map();
  private controlEventExtras: Map<EventType, DfxParam> = new Map();
  private controlEventTimeId: Map<EventType, number | undefined> = new Map();
  private controlEventSeekTime: Map<EventType, number> = new Map();
  private coldStartPlayback: Boolean = false;
  private coldStartMetadata: Boolean = false;

  private static curRemoteOutputDev: AbstractProperty<number>;
  private static curOutputDev: AbstractProperty<CurOutputDev>;
  private cachedProcessingDfxParam: DfxParam | undefined = undefined;
  private needRefreshOnDropdown: boolean = true;
  private sessionDestroyCallbackSet: Set<String> = new Set();
  private isFirstState: boolean = true;
  private localDeviceName: string = '';
  private playingSessionId: string = '';
  // private serviceStateMap: Map<string, collaborationServiceManager.State> =
  //   new Map<string, collaborationServiceManager.State>();
  private commonEventSubscriber: CommonEventManager.CommonEventSubscriber | null = null;

  public static getInstance(): CardMediaController {
    if (!CardMediaController.controller) {
      CardMediaController.controller = new CardMediaController();
      SessionInfoProvider.getInstance();
      CardMediaController.controller.initWorker();
      CardMediaController.controller.initCommonSubscriber();
    }
    if (CardMediaController.controller && CardMediaController.mediaTitleLink === undefined &&
      CardMediaController.controlMediaTitleLink === undefined) {
      CardMediaController.controller.initStorageLink();
    }
    return CardMediaController.controller;
  }

  private initCommonSubscriber() {
    CommonEventManager.createSubscriber({ 'events': ['usual.event.MEDIA_CAST_DISCONNECT',
      'usual.event.MEDIA_CAST_ERROR'] }, (error, commonEventSubscriber) => {
        if (error) {
          log.showError(`create commonEvent subscriber failed. Code: ${error.code}, message: ${error.message}`);
          return;
        }
        // 订阅通用事件
        this.commonEventSubscriber = commonEventSubscriber;
        try {
          CommonEventManager.subscribe(this.commonEventSubscriber, (err, data) => {
            if (data?.event === 'usual.event.MEDIA_CAST_DISCONNECT') {
              // 投播链接后异常断开
              try {
                promptAction.showToast({
                  message: $r('app.string.av_cast_disconnect'),
                  showMode: 2
                });
              } catch (err) {
                log.showError(`Failed to show toast about cast disconnect. Code: ${err.code}, message: ${err.message}`);
              }
            } else if (data?.event === 'usual.event.MEDIA_CAST_ERROR') {
              // 投播链接过程中异常断开
              try {
                promptAction.showToast({
                  message: $r('app.string.device_error'),
                  showMode: 2
                });
              } catch (err) {
                log.showError(`Failed to show toast about cast disconnect. Code: ${err.code}, message: ${err.message}`);
              }
            } else {
              log.showInfo('otherEvent' + data?.event);
            }
          });
        } catch (err) {
          log.showError(`common event subscribe failed. Code: ${err.code}, message: ${err.message}`);
        }
      });
  }

  /**
   * 子线程初始化
   */
  async initWorker() {
    // 静态切分DC开关
    if (!this.enableDc) {
      return;
    }
    log.showInfo(`init worker: ${TAG}`);
    messageChannel.registerCallObject(Constants.CARD_MEDIA_CONTROLLER, CardMediaController.controller);
    messageChannel.onMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, this.callByWorker); // 监听子线程消息
  }

  /**
   * 子线程调用方法，统一处理异步函数
   */
  private callByWorker = (parameter: WorkerMsgParameter) => {
    if (parameter.type !== undefined) {
      this.callOperation[parameter.type]?.(parameter);
    }
  }

  /**
   * 响应子线程操作回调，使用字面量对象优化switch case
   */
  private callOperation: Record<string, (parameter: WorkerMsgParameter) => void> = {
    'previous': (parameter: WorkerMsgParameter) => {
      this.callShowingPrevious();
    },
    'next': (parameter: WorkerMsgParameter) => {
      this.callShowingNext();
    },
    'play': (parameter: WorkerMsgParameter) => {
      this.callShowingPlay(parameter?.isColdStart || false);
    },
    'callPlay': (parameter: WorkerMsgParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.isColdStart !== undefined) {
        this.callPlay(parameter.sessionId, parameter?.isColdStart, parameter?.isForceTopSession);
      }
    },
    'pause': (parameter: WorkerMsgParameter) => {
      this.callShowingPause();
    },
    'loopMode': (parameter: WorkerMsgParameter) => {
      if (parameter?.loopMode !== undefined) {
        this.callLoopMode(parameter?.loopMode || 0);
      }
    },
    'favor': (parameter: WorkerMsgParameter) => {
      if (parameter?.assetId !== undefined && parameter?.isFavor !== undefined) {
        this.callFavorites(parameter?.assetId || '', parameter?.isFavor || false);
      }
    },
    'rewind': (parameter: WorkerMsgParameter) => {
      if (parameter?.skipIntervals !== undefined) {
        this.callRewindOrForward('rewind', parameter?.skipIntervals || 15);
      }
    },
    'fastForward': (parameter: WorkerMsgParameter) => {
      if (parameter?.skipIntervals !== undefined) {
        this.callRewindOrForward('fastForward', parameter?.skipIntervals || 15);
      }
    },
    'startHistoryApp': (parameter: WorkerMsgParameter) => {
      this.startHistoryApp();
    },
    'startShowingDefaultApp': (parameter: WorkerMsgParameter) => {
      this.startShowingDefaultApp();
    },
    'startShowing': (parameter: WorkerMsgParameter) => {
      if (parameter?.formId !== undefined) {
        this.startShowing(parameter?.formId, parameter?.skipInit || false, parameter?.forceUpdate || false);
      }
    },
    'seek': (parameter: WorkerMsgParameter) => {
      if (parameter?.time !== undefined && parameter?.time >= 0) {
        this.callSeek(parameter?.time);
      }
    },
    'setScenesType': (parameter: WorkerMsgParameter) => {
      if (parameter?.sceneType !== undefined) {
        globalStorage.setStringByKey('scenesType', parameter?.sceneType);
      }
    },
    'jumpInside': (parameter: WorkerMsgParameter) => {
      if (parameter?.isSwitch !== undefined && parameter?.curDeviceType !== undefined &&
        parameter?.curDeviceId !== undefined) {
        this.jumpInside(parameter.isSwitch, {
          deviceType: parameter.curDeviceType,
          deviceId: parameter.curDeviceId,
          deviceAddress: parameter.curDeviceAddress,
          networkId: parameter.curDeviceNetworkId,
        }, parameter.iconInfo, parameter.isLocal);
      }
    },
    'initCollectService': (parameter: WorkerMsgParameter) => {

    },
    'setAppStorage': (parameter: WorkerMsgParameter) => {
      if (parameter?.storageKey !== undefined) {
        AppStorage.setOrCreate(parameter?.storageKey, parameter?.storageValue);
      }
    },
    'startAimApp': (parameter: WorkerMsgParameter) => {
      if (parameter?.sessionId !== undefined) {
        this.startAimApp(parameter?.sessionId);
      }
    },
    'doSessionCollection': (parameter: WorkerMsgParameter) => {
      this.doSessionCollection();
    },
    'startCastControl': (parameter: WorkerMsgParameter) => {
      if (parameter?.sessionId !== undefined) {
        CastDeviceControl.getInstance().startControl(parameter?.sessionId, parameter?.bundleName);
      }
    },
    'panelStateChange': (parameter: WorkerMsgParameter) => {
      if (parameter?.targetPanel !== undefined) {
        this.panelStateChange(parameter?.targetPanel);
      }
    },
    'doSubscribeNotify': (parameter: WorkerMsgParameter) => {
      this.doSubscribeNotify();
    },
    'jumpAppWithScreenLock': (parameter: WorkerMsgParameter) => {
      this.jumpAppWithScreenLock(parameter?.sessionId);
    },
    'jumpOutside': (parameter: WorkerMsgParameter) => {
      this.jumpOutside();
    },
    'reportExpandShowDeviceList': (parameter: WorkerMsgParameter) => {
      if (parameter?.sessionId !== undefined && parameter?.startTime !== undefined) {
        this.reportExpandShowDeviceList(parameter?.sessionId, parameter?.startTime);
      }
    },
    'postNotificationCancelEvent': (parameter: WorkerMsgParameter) => {
      if (parameter?.notifyId !== undefined) {
        this.postNotificationCancelEvent(parameter?.notifyId, parameter?.from);
      }
    },
    'setNotificationFromDeviceChange': (parameter: WorkerMsgParameter) => {
      if (parameter?.isNotificationFromDeviceChange !== undefined) {
        this.setNotificationFromDeviceChange(parameter?.isNotificationFromDeviceChange);
      }
    },
    'setNtfShowing': (parameter: WorkerMsgParameter) => {
      if (parameter?.isMediaNtfShowing !== undefined) {
        this.setNtfShowing(parameter?.isMediaNtfShowing);
      }
    },
    'removeExistedNotification': (parameter: WorkerMsgParameter) => {
      if (parameter?.notifyId !== undefined && parameter?.forceRemove !== undefined) {
        this.removeExistedNotification(parameter?.notifyId, parameter?.forceRemove);
      }
    },
    'callGlobalStorage': (parameter: WorkerMsgParameter) => {
      if (parameter?.name !== undefined && parameter?.value !== undefined) {
        let storageData: SyncGlobalStorageInfo = {name: parameter?.name, value: parameter?.value};
        this.callGlobalStorage(storageData);
      }
    },
    'callGlobalContext': (parameter: WorkerMsgParameter) => {
      if (parameter?.name !== undefined && parameter?.value !== undefined) {
        GlobalContext.getInstance().setObject(parameter?.name, parameter?.value);
      }
    },
    'closeSubWindow': (parameter: WorkerMsgParameter) => {
      this.closeSubWindow();
    },
    'playAvQueue': (parameter: WorkerMsgParameter) => {
      if (parameter.bundleName !== undefined && parameter.avQueueId !== undefined) {
        this.playAvQueue(parameter.bundleName, parameter.avQueueId);
      }
    },
    'getHistoricalAndRecommendData': (parameter: WorkerMsgParameter) => {
      this.getHistoricalAndRecommendData();
    },
  }

  /**
   * 获取历史歌单和猜你喜欢列表数据
   */
  public async getHistoricalAndRecommendData() {
    MediaInfoProvider.getInstance().getHistoricalAndRecommendData();
  }

  /**
   * 从子线程同步的globalStorage
   */
  public callGlobalStorage(data: SyncGlobalStorageInfo) {
    log.showInfo(`callGlobalStorage ${JSON.stringify(data)}`);
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

  async doSessionCollection() {
    if (!this.sessionProvider) {
      log.showInfo('startShowing sessionProvider.getinstence');
      this.sessionProvider = await SessionInfoProvider.getInstance();
    } else {
      log.showInfo('startShowing sessionProvider.doSessionCollection');
      await this.sessionProvider.doSessionCollection(); // session数据刷新
    }
    let sessionId: string = this.sessionProvider?.sessionListCache?.[0] || 'default';
    AppStorage.setOrCreate('CurSessionId', sessionId);
    if (this.enableDc) {
      messageChannel.sendMessage('syncAppStorage', { name: 'CurSessionId', value: sessionId });
    }
    CastDeviceControl.getInstance()?.startControl(sessionId);
  }


  initStorageLink() {
    try {
      CardMediaController.mediaLoopModeLink = AppStorage.setAndRef('MediaLoopMode', null);
      CardMediaController.mediaTitleLink = AppStorage.setAndRef('MediaTitle', null);
      CardMediaController.songInfoLink = AppStorage.setAndRef('songInfoLink', {});
      CardMediaController.controlMediaTitleLink = AppStorage.setAndRef('ControlMediaTitle', null);
      CardMediaController.mediaArtistLink = AppStorage.setAndRef('MediaArtist', null);
      CardMediaController.mediaImgShowLink = AppStorage.setAndRef('MediaImgShow', null);
      CardMediaController.appIconShowLink = AppStorage.setAndRef('appIconShow', null);
      CardMediaController.mediaIconLink = AppStorage.setAndRef('MediaIcon', null);
      CardMediaController.mediaImgLink = AppStorage.setAndRef('MediaImg', null);
      CardMediaController.mediaPlayStateLink = AppStorage.setAndRef('MediaPlayState', null);
      CardMediaController.mediaEnableLink = AppStorage.setAndRef('MediaEnable', null);
      CardMediaController.mediaDisplayTagsLink = AppStorage.setAndRef('MediaDisplayTags', null);
      CardMediaController.mediaValidCommandsLink = AppStorage.setAndRef('MediaValidCommands', []);
      CardMediaController.mediaSkipIntervalsLink = AppStorage.setAndRef('MediaSkipIntervals', null)
      CardMediaController.mediaTypeLink = AppStorage.setAndRef('MediaType', null)
      CardMediaController.appNameLink = AppStorage.setAndRef('appName', null);
      CardMediaController.isVideoLink = AppStorage.setAndRef('isVideo', false);
      CardMediaController.mediaSpeedLink = AppStorage.setAndRef('MediaSpeed', 1);
      CardMediaController.hasLyricLink = AppStorage.setAndRef('hasLyric', false);
      CardMediaController.isChangeSongLink = AppStorage.setAndRef('isChangeSong', false);
      CardMediaController.isChangeAppLink = AppStorage.setAndRef('isChangeApp', false);
      CardMediaController.curRemoteOutputDev = AppStorage.setAndRef('CurRemoteDevSelect', -1);
      CardMediaController.curOutputDev = AppStorage.setAndRef('CurDevSelect', { deviceType: audio.DeviceType.SPEAKER, deviceId: -1 });
      CardMediaController.avQueueIdLink = AppStorage.setAndRef('CurAvQueueId', null);
      CardMediaController.playbackPositionLink = AppStorage.setAndRef('playbackPosition', {elapsedTime: 0, updateTime: 0});
      CardMediaController.isFavorLink = AppStorage.setAndRef('MediaIsFavor', false);
      CardMediaController.durationLink = AppStorage.setAndRef('Duration', null);
    } catch (err) {
      log.error(' do CardMediaController init task fail: ' + JSON.stringify(err));
    }
  }

  private isCast(sessionId: string): boolean {
    return this.sessionProvider?.avSessionDescriptorMap[sessionId]?.sessionTag === 'RemoteCast';
  }

  public getSessionChangeCallback(): LocalEventCallback {
    if (!this.sessionChangeCallback) {
      this.sessionChangeCallback = new LocalEventCallback((sessionId: string) => {
        log.showInfo(`sessionChanged sessionId: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
          sessionId?.substr(sessionId?.length - 5))}`);
        if (sessionId) {
          this.startShowingDefaultApp(sessionId, true);
        }
      });
    }
    return this.sessionChangeCallback;
  }

  getSessionDestroyCallback(): LocalEventCallback {
    log.showInfo(`getSessionDestroyCallback`)
    if (!this.sessionDestroyCallback) {
      this.sessionDestroyCallback = new LocalEventCallback(async (sessionId: string) => {
        log.showInfo('on sessionDestroy');
        this.sessionDestroyCallbackSet.delete(sessionId);
        this.commonInterface?.releaseCallback(sessionId);
        if (!this.sessionProvider || !this.sessionProvider.avSessionControllerMap.size) {
          log.error(`on sessionDestroy without sessionProvider return`);
          return;
        }
        this.sessionProvider.bundleNameMap[sessionId] = '';
        this.sessionProvider.abilityNameMap[sessionId] = '';
        this.sessionProvider.avSessionDescriptorMap.delete(sessionId);
        this.sessionProvider.avSessionControllerMap.delete(sessionId);
        if (this.showingController) {
          this.showingController = undefined;
        }
        this.startShowing(this.showingFormId as string);
      });
    }
    return this.sessionDestroyCallback;
  }


  // 用户行为打点
  public reportUE(eventType: EventType, reason:string, isJump: boolean = false, callingSessionId: string = '') {
    let sessionId: string = callingSessionId === '' ? this.sessionProvider?.topSessionId as string : callingSessionId;
    clearTimeout(this.controlEventTimeId.get(eventType));
    this.controlEventTimeId.set(eventType, undefined);
    this.controlEventMap.set(eventType, false);
    let startTime = this.controlEventStartTime.get(eventType) || new Date().getTime();
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    let version: string = this.sessionProvider?.appVersionMap.get(bundleName) || 'default';
    let dfxParam: DfxParam = {
      PNAMEID: this.pInfoName,
      PVERSIONID: this.pInfoVersion,
      PACKAGE_NAME: bundleName,
      DEVICE_TYPE: this.getDeviceType(),
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
  timeoutReportUE(eventType: EventType, extras: DfxParam = {}, sessionId: string = '') {
    let reason = 'playbackState or metadata change timeout';
    if (this.controlEventTimeId.get(eventType)) {
      log.showInfo(`timeoutReportUE eventType${eventType} has timer, return`);
      return;
    }
    this.controlEventMap.set(eventType, true);
    this.controlEventStartTime.set(eventType, new Date().getTime());
    this.controlEventExtras.set(eventType, extras);
    this.controlEventTimeId.set(eventType, setTimeout(() => {
      this.reportUE(eventType, reason, false, sessionId);
    }, extras.COLD_START ? 10000 : 3000));
  }

  // 状态回调正常打点
  playbackReport(state : AVSessionManager.AVPlaybackState) {
    this.controlEventMap.forEach((value, eventType) => {
      if (!value || !state) {
        return;
      }
      if (state.state) {
        this.statePlaybackReport(eventType as EventType, state.state);
      }
      if (state.position) {
        this.positionPlaybackReport(eventType as EventType, state.position);
      }
      if (state.loopMode !== undefined || state.isFavorite !== undefined) {
        this.loopOrFavoritePlaybackReport(eventType as EventType, state);
      }
    })
  }

  // 播放状态回调打点
  statePlaybackReport(eventType: EventType, state: AVSessionManager.PlaybackState) {
    if (eventType === EventType.LOCAL_DEVICE_PLAY) {
      // 冷启动特殊处理
      if (this.controlEventExtras.get(eventType)?.COLD_START) {
        this.coldStartPlayback = true;
        if (this.coldStartPlayback && this.coldStartMetadata) {
          this.coldStartPlayback = false;
          this.coldStartMetadata = false;
          this.reportUE(eventType, 'SUCCESS');
        }
      } else {
        if (state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY) {
          this.reportUE(eventType, 'SUCCESS');
        } else if (state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PAUSE) {
          this.reportUE(eventType, 'PLAYBACKSTATE_CHANGE_ERROR');
        }
      }
    } else if (eventType === EventType.LOCAL_DEVICE_PAUSE) {
      if (state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PAUSE) {
        this.reportUE(eventType, 'SUCCESS');
      } else {
        this.reportUE(eventType, 'PLAYBACKSTATE_CHANGE_ERROR');
      }
    }
  }

  // 进度状态回调打点
  positionPlaybackReport(eventType: EventType, position: AVSessionManager.PlaybackPosition) {
    if (eventType === EventType.LOCAL_DEVICE_FASTFORWARD || eventType === EventType.LOCAL_DEVICE_REWIND ||
      eventType === EventType.LOCAL_DEVICE_SEEK) {
      if (globalStorage.getStringByKey('scenesType') === 'controlCenter') {
        this.reportUE(eventType, 'SUCCESS');
        return;
      }
      let sessionId:string = this.sessionProvider?.topSessionId as string;
      let isVideo: boolean = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type === 'video';
      let time: number = this.controlEventSeekTime.get(eventType) as number - position.elapsedTime;
      if ((time >= (isVideo ? 3000 : 100)) || (time <= (isVideo ? -3000 : -100))) {
        this.reportUE(eventType, 'PLAYBACKSTATE_CHANGE_ERROR');
      } else {
        this.reportUE(eventType, 'SUCCESS');
      }
    }
  }

  // 收藏或者循环状态回调打点
  loopOrFavoritePlaybackReport(eventType: EventType, state: AVSessionManager.AVPlaybackState) {
    if (eventType === EventType.LOCAL_DEVICE_LOOPMODE && state.loopMode !== undefined) {
      if (state.loopMode === this.controlEventExtras.get(eventType)?.CONTROL_MODE) {
        this.reportUE(eventType, 'PLAYBACKSTATE_CHANGE_ERROR');
      } else {
        this.controlEventExtras.set(eventType, { CONTROL_MODE: state.loopMode })
        this.reportUE(eventType, 'SUCCESS');
      }
    } else if (eventType === EventType.LOCAL_FAVORITE && state.isFavorite !== undefined) {
      if (state.isFavorite === !!(this.controlEventExtras.get(eventType)?.CONTROL_MODE)) {
        this.reportUE(eventType, 'PLAYBACKSTATE_CHANGE_ERROR');
      } else {
        this.controlEventExtras.set(eventType, { CONTROL_MODE: state.isFavorite ? 1 : 0 })
        this.reportUE(eventType, 'SUCCESS');
      }
    }
  }

  // 信息回调正常打点
  metadataReport(newData: AVSessionManager.AVMetadata, lastMusicAssetId: string | number, lastmediaTitle: string) {
    this.controlEventMap.forEach((value, eventType) => {
      if (!value) {
        return;
      }
      if (eventType === EventType.LOCAL_DEVICE_NEXT || eventType === EventType.LOCAL_DEVICE_PREVIOUS) {
        if (newData.assetId !== lastMusicAssetId || newData.title !== lastmediaTitle) {
          this.reportUE(eventType, 'SUCCESS');
        } else {
          this.reportUE(eventType, 'METADATA_ERROR');
        }
      } else if ((eventType === EventType.LOCAL_DEVICE_PLAY && this.controlEventExtras.get(eventType)?.COLD_START) ||
        (newData.assetId !== undefined || newData.title !== undefined)) {
        this.coldStartMetadata = true;
        if (this.coldStartPlayback && this.coldStartMetadata) {
          this.coldStartPlayback = false;
          this.coldStartMetadata = false;
          this.reportUE(eventType as EventType, 'SUCCESS');
        }
      }
    })
  }

  /**
   * 防止频繁同一操作 防抖
   * @returns
   */
  debounce(): boolean {
    let currentTimeStamp = new Date().getTime();
    if (currentTimeStamp > this.preOrNextOperateTimeStamp &&
      currentTimeStamp - this.preOrNextOperateTimeStamp < this.OPERATE_MIN_INTERVAL) {
      log.warn(`next operate too frequency, currentTimeStamp:${currentTimeStamp},
        this.preOrNextOperateTimeStamp: ${this.preOrNextOperateTimeStamp}`);
      return false;
    }
    this.preOrNextOperateTimeStamp = currentTimeStamp;
    return true;
  }

  async isCurrentCastController(): Promise<boolean> {
    let isCast = false;
    return isCast;
  }

  async callSeek(time: number) {
    log.showInfo(`callSeek sessionProvider ${this.sessionProvider}`);
    this.controlEventSeekTime.set(EventType.LOCAL_DEVICE_SEEK, time);
    this.timeoutReportUE(EventType.LOCAL_DEVICE_SEEK);
    let currentTimeStamp = new Date().getTime();
    if (!this.sessionProvider) {
      return;
    }
    this.preOrNextOperateTimeStamp = currentTimeStamp;
    if (this.showingController) {
      log.showInfo(`callSeek showing is ${this.showingController}`);
      let seek: AVSessionManager.AVControlCommand = { command: 'seek', parameter: time };
      const dfx = this.getAppInfo(this.sessionProvider?.topSessionId);
      const sessionId = this.sessionProvider?.topSessionId;
       if (!sessionId) {
        return;
      }
      CommunicationUtil.doLocalEventNotify('seekDone', 'done');
      if (this.enableDc) {
        messageChannel.sendMessage('syncLocalNotify', { name: 'seekDone', value: 'done' });
      }
      await this.commonInterface?.sendControlCommand(this.sessionProvider?.topSessionId, seek).then(() => {
      }).catch((errorCode: BusinessError) => {
        let dfxParam : DfxParam = { PACKAGE_NAME: dfx.PACKAGE_NAME, REASON: errorCode.message, OPERATE_TYPE: 'SEEK',
          COLD_START: false, APP_TYPE: dfx.APP_TYPE };
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
        log.error(`callSeek showing catch ${errorCode}`);
      });
    }
  }

  async callShowingNext() {
    log.showInfo('callNext')
    if (!this.debounce()) {
      return;
    }
    this.timeoutReportUE(EventType.LOCAL_DEVICE_NEXT);
    if (this.showingController) {
      log.showInfo(`callNext showing is ${this.showingController}`);
      let next: AVSessionManager.AVControlCommand = { command: 'playNext', parameter: undefined };
      const dfx = this.getAppInfo(this.sessionProvider?.topSessionId);
      await this.commonInterface?.sendControlCommand(this.sessionProvider?.topSessionId, next).then(() => {
      }).catch((errorCode: BusinessError) => {
        let dfxParam : DfxParam = { PACKAGE_NAME: dfx.PACKAGE_NAME, REASON: errorCode.message, OPERATE_TYPE: 'NEXT',
          COLD_START: false, APP_TYPE: dfx.APP_TYPE };
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
        log.error(`callNext showing catch ${errorCode}`);
      });
    }
  }

  async callShowingPrevious() {
    log.showInfo('callPrevious');
    if (!this.debounce()) {
      return;
    }
    this.timeoutReportUE(EventType.LOCAL_DEVICE_PREVIOUS);
    if (this.showingController) {
      log.showInfo(`callPrevious showing is ${this.showingController}`);
      let previous: AVSessionManager.AVControlCommand = { command: 'playPrevious', parameter: undefined };
      const dfx = this.getAppInfo(this.sessionProvider?.topSessionId);
      await this.commonInterface?.sendControlCommand(this.sessionProvider?.topSessionId, previous).then(() => {
      }).catch((errorCode: BusinessError) => {
        let dfxParam : DfxParam = { PACKAGE_NAME: dfx.PACKAGE_NAME, REASON: errorCode.message, OPERATE_TYPE: 'PREVIOUS',
          COLD_START: false, APP_TYPE: dfx.APP_TYPE };
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
        log.error(`callPrevious showing catch ${errorCode}`);
      });
    }
  }


  /**
   * 收藏
   * @param assetID
   */
  async callFavorites(assetID: string | number, isFavor: boolean) {
    log.showInfo(`callFavorites`);
    if (!this.debounce()) {
      return;
    }
    this.timeoutReportUE(EventType.LOCAL_FAVORITE, { CONTROL_MODE: isFavor ? 1 : 0 });
    let toggleFavorite: AVSessionManager.AVControlCommand = { command: 'toggleFavorite', parameter: assetID };
    const dfx = this.getAppInfo(this.sessionProvider?.topSessionId);
    if (this.showingController) {
      log.showInfo(`callFavorites showing is ${this.showingController}`);
      await this.commonInterface?.sendControlCommand(this.sessionProvider?.topSessionId,
        toggleFavorite).then(() => {
      }).catch((errorCode: BusinessError) => {
        let dfxParam : DfxParam = { PACKAGE_NAME: dfx.PACKAGE_NAME, REASON: errorCode.message, OPERATE_TYPE: 'FAVORITE',
          COLD_START: false, APP_TYPE: dfx.APP_TYPE };
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
        log.error(`callFavorites showing catch ${errorCode}`);
      });
    }
  }

  /**
   * 快进快退
   * @param command
   * @param parameter
   */
  async callRewindOrForward(command: AVSessionManager.AVControlCommandType, parameter: number) {
    log.showInfo('callRewindOrForward')
    if (!this.debounce()) {
      return;
    }
    const dfx = this.getAppInfo(this.sessionProvider?.topSessionId);
    let eventType: EventType;
    let operateType: string;
    let rewindOrForwardTime:number;
    let curPosition = globalStorage.getNumberByKey('curPosition') as number;
    if (command === 'fastForward') {
      eventType = EventType.LOCAL_DEVICE_FASTFORWARD;
      operateType = 'FASTFORWARD';
      rewindOrForwardTime = (curPosition + parameter);
      let avMetadata: AVSessionManager.AVMetadata | undefined =
        await this.commonInterface?.getAVMetadata(this.sessionProvider?.topSessionId as string);
      rewindOrForwardTime = (curPosition + parameter) > (avMetadata?.duration as number) ?
        (avMetadata?.duration as number) : (curPosition + parameter);
    } else {
      eventType = EventType.LOCAL_DEVICE_REWIND;
      operateType = 'REWIND';
      rewindOrForwardTime = (curPosition - parameter) < 0 ? 0 : (curPosition - parameter);
    }
    this.controlEventSeekTime.set(eventType, rewindOrForwardTime);
    this.timeoutReportUE(eventType, { CONTROL_TIME: parameter });
    if (this.showingController) {
      log.showInfo(`callRewindOrForward showing is ${this.showingController}`);
      let rewindOrForwardCommand: AVSessionManager.AVControlCommand = { command, parameter };
      await this.commonInterface?.sendControlCommand(this.sessionProvider?.topSessionId,
        rewindOrForwardCommand).then(() => {
      }).catch((errorCode: BusinessError) => {
        let dfxParam : DfxParam = { PACKAGE_NAME: dfx.PACKAGE_NAME, REASON: errorCode.message,
          OPERATE_TYPE: operateType, COLD_START: false, APP_TYPE: dfx.APP_TYPE };
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
        log.error(`callRewindOrForward showing catch ${errorCode}`);
      });
    }
  }

  async callShowingPlay(isColdStart: boolean) {
    log.showInfo(`callPlay`);
    if (!this.debounce()) {
      return;
    }
    this.timeoutReportUE(EventType.LOCAL_DEVICE_PLAY, { COLD_START: isColdStart });
    if (this.showingController) {
      log.showInfo(`callPlay showing is ${this.showingController}`);
      let play: AVSessionManager.AVControlCommand = { command: 'play', parameter: undefined };
      const dfx = this.getAppInfo(this.sessionProvider?.topSessionId);
      await this.commonInterface?.sendControlCommand(this.sessionProvider?.topSessionId, play).then(() => {
      }).catch((errorCode: BusinessError) => {
        let dfxParam : DfxParam = { PACKAGE_NAME: dfx.PACKAGE_NAME, REASON: errorCode.message, OPERATE_TYPE: 'PLAY',
          COLD_START: false, APP_TYPE: dfx.APP_TYPE };
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
        log.error(`callPlay showing catch ${errorCode}`);
      });
    }
  }

  async callPlay(sessionId: string, isColdStart: boolean, isForceTopSession: boolean = false) {
    log.showInfo(`callPlay: ${isColdStart}, ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
    sessionId?.substr(sessionId?.length - 5))} isForceTopSession ${isForceTopSession}`);
    this.timeoutReportUE(EventType.LOCAL_DEVICE_PLAY, { COLD_START: isColdStart }, sessionId);
    let play: AVSessionManager.AVControlCommand;
    if (isForceTopSession) {
      play = { command: 'play', parameter: sessionId };
    } else {
      play = { command: 'play' };
    }
    let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
    let appType: string = this.sessionProvider?.avSessionDescriptorMap[sessionId]?.type;
    await this.commonInterface?.sendControlCommand(sessionId, play).then(() => {
    }).catch((errorCode : BusinessError) => {
      let dfxParam : DfxParam = { PACKAGE_NAME: bundleName, REASON: errorCode.message, OPERATE_TYPE: 'PLAY',
        COLD_START: isColdStart, APP_TYPE: appType };
      this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
    });
  }

  async callShowingPause() {
    log.showInfo('callPause');
    if (!this.debounce()) {
      return;
    }
    this.timeoutReportUE(EventType.LOCAL_DEVICE_PAUSE);
    if (this.showingController) {
      log.showInfo(`callPause showing is ${this.showingController}`);
      let pause: AVSessionManager.AVControlCommand = { command: 'pause', parameter: undefined };
      const dfx = this.getAppInfo(this.sessionProvider?.topSessionId);
      await this.commonInterface?.sendControlCommand(this.sessionProvider?.topSessionId, pause).then(() => {
        ImmersiveSysEventUtils.reportMediaCycleEvent();
      }).catch((errorCode: BusinessError) => {
        let dfxParam : DfxParam = { PACKAGE_NAME: dfx.PACKAGE_NAME, REASON: errorCode.message, OPERATE_TYPE: 'PAUSE',
          COLD_START: false, APP_TYPE: dfx.APP_TYPE };
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
        log.error(`callPause showing catch ${errorCode}`);
      });
    }
  }

  async callLoopMode(loopMode: number) {
    log.showInfo(`callLoopMode is ${loopMode}`);
    if (!this.debounce()) {
      return;
    }
    this.timeoutReportUE(EventType.LOCAL_DEVICE_LOOPMODE, { CONTROL_MODE: loopMode });
    if (this.showingController) {
      log.showInfo(`callLoopMode showing is ${this.showingController}`);
      let setLoopMode: AVSessionManager.AVControlCommand = { command: 'setLoopMode', parameter: loopMode };
      const dfx = this.getAppInfo(this.sessionProvider?.topSessionId);
      await this.commonInterface?.sendControlCommand(this.sessionProvider?.topSessionId,
        setLoopMode).then(() => {
      }).catch((errorCode: BusinessError) => {
        let dfxParam : DfxParam = { PACKAGE_NAME: dfx.PACKAGE_NAME, REASON: errorCode.message, OPERATE_TYPE: 'LOOP',
          COLD_START: false, APP_TYPE: dfx.APP_TYPE};
        this.sessionProvider?.reportScenesHiEvent(EventType.LOCAL_CONTROL_FAILED, dfxParam, false);
        log.error(`callLoopMode showing catch ${errorCode}`);
      });
    }
  }

  waitCommandProcessToReport(eventType: EventType, dfxParam: DfxParam, isDone: boolean): void {
    let dfxParamProcessed: DfxParam = dfxParam;
    if (eventType === EventType.LOCAL_DEVICE_LOOPMODE) {
      if (isDone && dfxParamProcessed.TIME) {
        if (!this.cachedProcessingDfxParam) {
          log.showInfo('loop mode dfx report endTime without startTime, quit');
          return;
        }
        dfxParamProcessed.TIME_COST = this.cachedProcessingDfxParam.TIME ?
          (dfxParamProcessed.TIME - this.cachedProcessingDfxParam.TIME) : 0;
        this.cachedProcessingDfxParam = undefined;
      } else {
        this.cachedProcessingDfxParam = dfxParamProcessed;
        return;
      }
    }
    this.sessionProvider?.reportScenesHiEvent(eventType, dfxParamProcessed, true);
  }

  getAppInfo(sessionId: string | undefined): DfxParam {
    let dfxParam: DfxParam = {
      PACKAGE_NAME: '',
      APP_TYPE: 'audio',
    };
    if (sessionId) {
      let aliveSessionDes: AVSessionManager.AVSessionDescriptor =
        this.sessionProvider?.avSessionDescriptorMap[sessionId];
      dfxParam.PACKAGE_NAME = aliveSessionDes?.elementName?.bundleName || '';
      dfxParam.APP_TYPE = aliveSessionDes?.type || 'audio';
    }
    return dfxParam;
  }

  getFold(): number {
    if (DeviceHelper.isPhone()) {
      if (DeviceHelper.isBarPhone()) {
        return -1;
      }
      return CommonUtils.isFoldExpanded() ? (CommonUtils.isUltraScreenProductInGState() ? 11 : 1) : 2;
    }
    return -1;
  }

  getDeviceModelType(): string {
    if (DeviceHelper.isPhone()) {
      return 'phone';
    } else if (DeviceHelper.isPC()) {
      return '2in1';
    } else if (DeviceHelper.isPad()) {
      return 'pad';
    }
    return 'other';
  }

  getDeviceType(): number | undefined {
    const deviceType: number | undefined = (CardMediaController.curRemoteOutputDev.get() >= 0) ?
      CardMediaController.curRemoteOutputDev.get() : CardMediaController.curOutputDev.get().deviceType;
    return deviceType;
  }

  getScreenStatus(): number {
    if (DeviceHelper.getOrientation() === 1 || DeviceHelper.getOrientation() === 3 ) {
      return 1;
    } else {
      return 0;
    }
  }

  /**
   * 获取本应用的包名和版本信息
   */
  async getBundleInfo() {
    let bundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
    let bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlag);
    if (!bundleInfo) {
      log.info(' get bundleInfo error ');
    }
    log.info(' get bundleInfo, name:' + bundleInfo.name + ', version:' + bundleInfo.versionName);
    globalStorage.setStringByKey('packageName', bundleInfo.name);
    globalStorage.setStringByKey('packageVersion', bundleInfo.versionName);
    this.pInfoName = bundleInfo.name;
    this.pInfoVersion = bundleInfo.versionName;
  }

  public getShowingMediaId(): string | undefined {
    log.debug(` updateForm MediaId : ${this.showingMediaId}`);
    return this.showingMediaId;
  }

  public getShowingPlayState(): boolean {
    if (this.showingPlayState) {
      return (this.showingPlayState?.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
        this.showingPlayState?.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING);
    }
    return false;
  }

  async setShowingAVSessionListener(sessionId: string, avSessionController: AVSessionManager.AVSessionController,
                                    isStartDefault?: boolean, isUpdate?: boolean) {
    log.warn(`newSession: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))} | ${isStartDefault} | ${isUpdate}`);
    if (!avSessionController) {
      log.error(' set AVSession listener but avSessionController is null');
      return;
    }
    let playbackState: AVSessionManager.AVPlaybackState = await avSessionController.getAVPlaybackState();
    if ((!DeviceHelper.isPC() || avSessionController.sessionId === this.sessionProvider?.topSessionId)) {
      AppStorage.setOrCreate('MediaPlayState', playbackState.state);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', { name: 'MediaPlayState', value: playbackState.state })
      }
    }
    if (playbackState.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
      playbackState.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
      this.isFirstState = false;
    } else {
      this.isFirstState = true;
    }
    log.showInfo(`set session destroy listener: ${playbackState.state}`);

    this.commonInterface?.onValidCommandChange(avSessionController, isUpdate as boolean,
      (data: Array<AVSessionManager.AVControlCommandType>, type: string) => {
        log.showInfo(`onValidCommandChange in ${JSON.stringify(data)}, ${type}`);
        if (avSessionController.sessionId !== this.sessionProvider?.topSessionId) {
          log.showInfo('current sessionId is not target sessionId , not refresh validcommand ');
          return;
        }
        try {
          if (!data) {
            log.showInfo(`onValidCommandChange whit no CardMediaController`);
            return;
          }
          if (type && data) {
            CardMediaController?.mediaValidCommandsLink?.set(data);
            CommunicationUtil.doLocalEventNotify('ntfDataUpdate', { validCommands: data } as ShowingMesTS);
            if (this.enableDc) {
              // 通知子线程，validCommands变化
              messageChannel.sendMessage('syncMediaData', { validCommands: data });
            }
          } else {
            log.showInfo(`onValidCommandChange callback: no type or data`);
          }
        } catch (err) {
          log.error(`onValidCommandChange error: ${err}`)
        }
      });
    this.commonInterface?.onMetadataChange(avSessionController, isUpdate as boolean,
      (data: AVSessionManager.AVMetadata, type: string, extraData?: ExtraData) => {
        log.showInfo(`Metadata change showing avsession callback, assetId=${CommonUtils.getMaskStr(data?.assetId)}`);
        log.showInfo(`Metadata change showing avsession callback, duration=${data?.duration}, type=${type}`);
        if (!data) {
          return
        }
        if (avSessionController.sessionId !== this.sessionProvider?.topSessionId) {
          log.showInfo(`current sessionId is not target sessionId , not refresh metadata, curSessionId:
            ${avSessionController.sessionId?.length < 10 ? '' : (avSessionController.sessionId?.substr(0, 5) + '**' +
            avSessionController.sessionId?.substr(avSessionController.sessionId?.length - 5))}`);
          return;
        }
        let lastMediaTitle = CardMediaController.controlMediaTitleLink?.get() as string;
        this.metadataReport(data, this.lastMusicAssetId, lastMediaTitle);
        let bundleName: string = this.sessionProvider?.bundleNameMap[sessionId];
        if (bundleName === 'com.ohos.music' && data.description) {
          CardMediaController.songInfoLink?.set(this.getSongInfo(data.description));
        } else {
          CardMediaController.songInfoLink?.set({});
        }
        log.showInfo(`Metadata change callback img:${data.title} `);
        try {
          if ((type === 'locale') ) {
            log.showInfo('Local receiving local callback, Cast receiving Cast callback');
            this.doMetaDataChangeCallback(data, type, extraData);
          }
        } catch (err) {
          log.error('onMetadataChange error: ', err)
        }
      });
    this.commonInterface?.onPlaybackStateChanged(avSessionController,
      isUpdate as boolean, (state: AVSessionManager.AVPlaybackState, type: string) => {
      log.showInfo(`playstate change showing avsession callback : ${JSON.stringify(state)}, ${type}`);
      if (!state) {
        log.showError(`playstate change is empty`);
        return;
      }
      if (state.state !== undefined) {
        const needClearTimer = state.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
          state.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING;
        if (needClearTimer) {
          this.playingSessionId = avSessionController.sessionId;
          setTimeout(() => {
            log.showInfo(`state is play, cancel remove Notification Timer, timerId: ${this.removeNotificationTimer}`);
            this.clearRemoveNotificationTimer();
          }, 600)
        } else if (this.playingSessionId === avSessionController.sessionId) {
          // 上一个播放中的状态属于当前应用才开启定时器
          this.startRemoveNotificationTimer();
        } else {
          log.showInfo('latest playing session is not current session, do not start Remove Notification Timer');
        }
      }

      this.playbackReport(state);
      if (avSessionController.sessionId !== this.sessionProvider?.topSessionId) {
        log.showInfo(`current sessionId is not target sessionId , dont refresh state, curSessionId:
          ${avSessionController.sessionId?.length < 10 ? '' : (avSessionController.sessionId?.substr(0, 5) + '**' +
          avSessionController.sessionId?.substr(avSessionController.sessionId?.length - 5))}`);
        return;
      }
      if (!!state.state && this.isFirstState && !DeviceHelper.isPC()) {
        AppStorage.setOrCreate('MediaPlayState', state.state);
        if (this.enableDc) {
          messageChannel.sendMessage('syncAppStorage', { name: 'MediaPlayState', value: state.state });
        }
        this.isFirstState = false;
      } else {
        this.isFirstState = true;
      }
        this.showingPlayState = state;
        let showingMes: ShowingMesTS = {};

      if (state.state !== undefined) {
        showingMes = {
          playState: this.showingPlayState?.state,
          isFavor: state.isFavorite ? state.isFavorite : undefined,
          loopMode: state.loopMode ? state.loopMode : undefined,
          hasMedia: true,
        }
      }
      if (state.position != undefined) {
        showingMes.position = state.position;
        showingMes.speed = state.speed;
        showingMes.hasMedia = true;
      }
      if (state.extras && state.extras.duration !== undefined && state.extras.duration > 0) {
        showingMes.duration = state.extras.duration as number
      }
      if (state.isFavorite != undefined) {
        showingMes.isFavor = this.showingPlayState.isFavorite;
        showingMes.hasMedia = true;
      }
      if (state.loopMode != undefined) {
        showingMes.loopMode = this.showingPlayState.loopMode;
        showingMes.hasMedia = true;
      }
      if (type === 'cast' && state.isFavorite == undefined) {
        showingMes.isFavor = false;
      }
      CardMediaController.controllerCallback(showingMes);
    });
  }

  public static on(event: 'mediaUpdate', callback: LocalEventCallback, notifyId: string) {
    CommunicationUtil.addLocalEventListener(event, callback);
  }

  public static off(event: 'mediaUpdate', callback: LocalEventCallback, notifyId: string) {
    CommunicationUtil.removeLocalEventListener(event, callback);
  }

  /**
   * controller回调，改变当前数据显示
   * @param mediaInfo
   */
  static async controllerCallback(mediaInfo: ShowingMesTS) {
    let isChangeApp: boolean = false;
    if (mediaInfo.appName != undefined) {
      log.showInfo(`parse media data:appName=${mediaInfo.appName},last=${CardMediaController.controller?.lastAppName}`);
      if (CardMediaController.controller?.lastAppName &&
        CardMediaController.controller?.lastAppName !== mediaInfo?.appName) {
        log.showError(`parse media data: change app name`);
        isChangeApp = true;
      }
      if (CardMediaController.controller) {
        CardMediaController.controller.lastAppName = mediaInfo.appName;
      }
    }
    CardMediaController.isChangeAppLink?.set(isChangeApp);
    let isChangeSong: boolean = false;
    let songInfo = CardMediaController.songInfoLink?.get() || {};
    if (mediaInfo.musicAssetId != undefined) {
      log.showInfo(`parse media data: musicAssetId=${CommonUtils.getMaskStr(mediaInfo.musicAssetId as string || '')}`);
      let lastMediaTitle = CardMediaController.controlMediaTitleLink?.get() as string;
      if (CardMediaController.controller?.lastMusicAssetId &&
        CardMediaController.controller?.lastMusicAssetId !== mediaInfo?.musicAssetId &&
        lastMediaTitle !== songInfo.songName) {
        log.showError(`parse media data: change song name`);
        isChangeSong = true;
      }
      if (mediaInfo.lyric === undefined && (isChangeSong || isChangeApp)) {
        mediaInfo.lyric = '';
      }
      if (CardMediaController.controller) {
        CardMediaController.controller.lastMusicAssetId = mediaInfo.musicAssetId;
      }
    }
    if (mediaInfo.lyric && mediaInfo.lyric.startsWith('[')) {
      CardMediaController.hasLyricLink?.set(true);
    } else if (mediaInfo.lyric === '') {
      CardMediaController.hasLyricLink?.set(false);
    }
    CardMediaController.isChangeSongLink?.set(isChangeSong);
    if (mediaInfo.lyric && songInfo && songInfo.songName && songInfo.songArtist) {
      mediaInfo.musicTitle = songInfo.songName + '-' + songInfo.songArtist;
      mediaInfo.musicAuthor = songInfo.songArtist;
      mediaInfo.controlMediaTitle = songInfo.songName;
      CardMediaController.controlMediaTitleLink?.set(mediaInfo.controlMediaTitle);
      CardMediaController.mediaArtistLink?.set(mediaInfo.musicAuthor);
      CardMediaController.mediaTitleLink?.set(mediaInfo.musicTitle);
    } else {
      if (mediaInfo.musicAuthor != undefined || isChangeApp) {
        CardMediaController.mediaArtistLink?.set(mediaInfo.musicAuthor);
      }
      if (mediaInfo.musicTitle != undefined || isChangeApp) {
        mediaInfo.controlMediaTitle = mediaInfo.musicTitle;
        CardMediaController.controlMediaTitleLink?.set(mediaInfo.musicTitle);
        if (mediaInfo.lyric && mediaInfo.musicTitle !== undefined && mediaInfo.musicAuthor !== undefined) {
          mediaInfo.musicTitle = mediaInfo.musicTitle + '-' + mediaInfo.musicAuthor;
        }
        CardMediaController.mediaTitleLink?.set(mediaInfo.musicTitle);
      }
    }
    log.showInfo(`callback : set displayTags : ${mediaInfo.displayTags}`);
    CardMediaController.mediaDisplayTagsLink?.set(mediaInfo?.displayTags || null);
    if (CardMediaController.controller?.enableDc) {
      // 通知子线程，媒体信息变化
      mediaInfo.isChangeApp = isChangeApp;
      mediaInfo.isChangeSong = isChangeSong;
      messageChannel.sendMessage('syncMediaData', mediaInfo);
    } else {
      CommunicationUtil.doLocalEventNotify('ntfDataUpdate', mediaInfo);
    }
    if (mediaInfo.musicPic !== undefined || isChangeApp) {
      let tempPic = CardMediaController.mediaImgLink?.get();
      let needRelease = !!tempPic && typeof tempPic === 'object'; // 是否需要释放图片内存
      if (!mediaInfo.musicPic) {
        // 清除图片
        log.showInfo('callback: reset mediaImg');
        CardMediaController.mediaImgLink?.set(undefined);
        CardMediaController.mediaImgShowLink?.set(false);
      } else if (typeof mediaInfo.musicPic === 'string') {
        if (CommonUtils.isBase64Image(mediaInfo.musicPic)) {
          // base64图片
          log.showInfo('callback: set mediaImg to base64');
          CardMediaController.mediaImgLink?.set(mediaInfo.musicPic);
          CardMediaController.mediaImgShowLink?.set(true);
        } else {
          // url图片
          log.showInfo(`callback: unset mediaImg with url ${mediaInfo.musicPic}`);
          needRelease = false; // 图片不更新，不需要释放图片内存
        }
      } else if (typeof mediaInfo.musicPic === 'object') {
        // pixelMap图片
        log.showInfo('callback: set mediaImg to pixelMap');
        CardMediaController.mediaImgLink?.set(mediaInfo.musicPic);
        CardMediaController.mediaImgShowLink?.set(true);
        if (!isChangeApp && CardMediaController.controller &&
          CardMediaController.controller.lastPixelMapId === mediaInfo.musicAssetId) {
          needRelease = false;
        }
        if (CardMediaController.controller) {
          CardMediaController.controller.lastPixelMapId = mediaInfo.musicAssetId;
        }
      }
      if (needRelease) {
        PixelMapUtil.addName(tempPic as PixelMap, 'Media_Control_Release');
        (tempPic as PixelMap).release();
      }
    }
    mediaInfo.musicPic = undefined;
    if (mediaInfo.playState != undefined) {
      CardMediaController.mediaPlayStateLink?.set(mediaInfo.playState);
    }
    if (mediaInfo.duration != undefined) {
      CardMediaController.durationLink?.set(mediaInfo.duration);
    }
    if (mediaInfo.hasMedia != undefined) {
      CardMediaController.mediaEnableLink?.set(mediaInfo.hasMedia);
      if (!mediaInfo.hasMedia && CardMediaController.controller) {
        CardMediaController.controller.lastPixelMapId = undefined;
      }
    }
    if (mediaInfo.mediaPlayerIcon != undefined) {
      if (!mediaInfo.mediaPlayerIcon) {
        CardMediaController.mediaIconLink?.set(undefined);
        CardMediaController.appIconShowLink?.set(false);
      } else {
        CardMediaController.mediaIconLink?.set(mediaInfo.mediaPlayerIcon);
        CardMediaController.appIconShowLink?.set(true);
      }
    }
    if (mediaInfo.appName !== undefined) {
      CardMediaController.appNameLink?.set(mediaInfo.appName);
    }
    if (mediaInfo.validCommands !== undefined) {
      log.showInfo(`controllerCallback validCommands: ${mediaInfo.validCommands}`)
      CardMediaController.mediaValidCommandsLink?.set(mediaInfo.validCommands);
    }
    if (mediaInfo.skipIntervals !== undefined || isChangeApp || isChangeSong) {
      CardMediaController.mediaSkipIntervalsLink?.set(mediaInfo.skipIntervals);
    }
    if (mediaInfo.mediaType != undefined) {
      CardMediaController.mediaTypeLink?.set(mediaInfo.mediaType);
    }
    if (mediaInfo.loopMode != undefined) {
      CardMediaController.mediaLoopModeLink?.set(mediaInfo.loopMode);
    } else if (isChangeApp) {
      CardMediaController.mediaLoopModeLink?.set(undefined);
    }
    if (mediaInfo.speed !== undefined ) {
      CardMediaController.mediaSpeedLink?.set(mediaInfo.speed);
    } else if (isChangeApp || isChangeSong) {
      CardMediaController.mediaSpeedLink?.set(1);
    }

    if (mediaInfo.avQueueId != undefined) {
      log.showInfo(`controllerCallback avQueueId: ${mediaInfo.avQueueId}`);
      CardMediaController.avQueueIdLink?.set(mediaInfo.avQueueId);
    } else {
      log.showInfo(`controllerCallback avQueueId is undefined`);
      CardMediaController.avQueueIdLink?.set(undefined);
    }
    if (mediaInfo.position !== undefined) {
      if (mediaInfo.position.elapsedTime >= 0 && mediaInfo.position.updateTime < 1) {
        mediaInfo.position.updateTime = new Date().getTime();
      }
      CardMediaController.playbackPositionLink?.set(mediaInfo.position);
    } else if (isChangeSong) {
      mediaInfo.position = {elapsedTime: 0, updateTime: new Date().getTime()};
      CardMediaController.playbackPositionLink?.set(mediaInfo.position);
    }
    if (mediaInfo.isFavor !== undefined) {
      CardMediaController.isFavorLink?.set(mediaInfo.isFavor);
    }
    mediaInfo.isCastController = await CardMediaController.controller?.isCurrentCastController() || false;
    CommunicationUtil.doLocalEventNotify('mediaUpdate', mediaInfo);
    if (CardMediaController.controller?.enableDc) {
      messageChannel.sendMessage('syncMediaUpdate', mediaInfo);
    }
    let newMediaInfo = ObjectCopyUtil.deepClone(mediaInfo);
    if (newMediaInfo.lyric && newMediaInfo.lyric !== undefined) {
      newMediaInfo.lyric = newMediaInfo.lyric.length.toString();
    }
    log.showInfo(`controllerCallback: ${JSON.stringify(newMediaInfo)}`);
  }

  getSongInfo(data: string):SongInfo {
    let songInfo: SongInfo = {};
    let songInfoList = data.split(';');
    songInfo.songName = songInfoList[0];
    songInfo.songArtist = songInfoList[1];
    return songInfo;
  }

  async getLocalDeviceName() {
    let displayName = await CommonUtils.getLocalDeviceName();
    let tempDeviceName: Resource = $r('app.string.LocalDevice');
    let tempDeviceNameStr = await this.context?.resourceManager.getStringValue(tempDeviceName.id);
    this.localDeviceName = tempDeviceNameStr + (' (' + displayName + ')');
  }

  /**
   * 播控卡片显示数据刷新
   * @param formId
   * @param skipInit
   */
  async startShowing(formId: string, skipInit: boolean = false, forceUpdate: boolean = false) {
    log.showInfo(` startshowing with id : ${formId}, ${skipInit}`);
    this.showingFormId = formId;
    if (!skipInit) {
      let newMediaType: AVSessionManager.AVSessionType | undefined = 'audio'
      if (CardMediaController.mediaTypeLink?.get() === 'video' && CardMediaController.isVideoLink?.get()) {
        newMediaType = 'video'
      }
      if (this.showingMesHistoryTitle !== CardMediaController.mediaTitleLink?.get() &&
        !this.isShowingMesHistory) {
        CardMediaController.controllerCallback({
          musicTitle: false,
          musicAuthor: false,
          musicPic: false,
          mediaPlayerIcon: false,
          playState: 0,
          hasMedia: false,
          validCommands: [],
          mediaType: newMediaType,
          appName: false,
          skipIntervals: 15,
          musicAssetId: '',
          loopMode: '',
        });
      }
    }
    // init session provider
    if (!this.sessionProvider) {
      log.showInfo('startShowing sessionProvider.getinstence');
      this.sessionProvider = await SessionInfoProvider.getInstance();
    } else {
      log.showInfo('startShowing sessionProvider.doSessionCollection');
      await this.sessionProvider.doSessionCollection(); // session数据刷新
    }

    if (!this.sessionProvider) {
      log.error(' getMetadataFromAVSession find no sessionProvider error');
      return;
    }
    //历史歌单播放后，播控卡片状态未杀死不执行
    SessionInfoProvider.on('deviceNotification', this.getDeviceNotificationCallback())
    // init common interface
    if (!this.commonInterface) {
      this.commonInterface = new CommonInterface();
      this.commonInterface.init(this.sessionProvider);
    }
    // get target session id
    const sessionId = this.sessionProvider?.topSessionId || 'default';

    // refresh all info
    if (AppStorage.get('isNotificationFromDeviceChange')) {
      CommunicationUtil.doLocalEventNotify('deviceNotification', sessionId);
    } else {
      await this.refreshAllInfo(sessionId, false, false, forceUpdate);
    }
    // add session listener
    if (!this.isShowingListened) {
      SessionInfoProvider.on('topSessionChangeHis', this.getTopSessionChangeCallback())
      SessionInfoProvider.on('controllerChanged', this.getControllerChangeCallback())
      SessionInfoProvider.on('sessionChanged', this.getSessionChangeCallback());
      SessionInfoProvider.on('sessionDestroy', this.getSessionDestroyCallback());
      try {
        CollaborationRegisterManager.getInstance().register(TAG, this.collaborationCallback);
      } catch (error) {
        log.showInfo(`subscribeServiceState errorcode =: ${error}.`);
      }
      this.isShowingListened = true;
    }
    this.getBundleInfo();
  }

  private collaborationCallback: CollaborationCallBack = {
    // callBack: (result: collaborationServiceManager.ServiceStateInfo) => {
    //   log.showInfo(`subscribeServiceState deviceId is: ${result.deviceId?.length < 10 ? '' :
    //     (result.deviceId?.substr(0, 5) + '**' + result.deviceId?.substr(result.deviceId?.length - 5))},
    //     serviceName is: ${result.serviceName}, state is: ${result.state}`);
    //   this.serviceStateMap[result.serviceName] = result.state;
    //   AppStorage.setOrCreate('serviceStateMap', this.serviceStateMap);
    //   // PAD协同
    //   let isConnectedPadCar: boolean =
    //     this.serviceStateMap['PadCarCollaboration-Dual'] === collaborationServiceManager.State.CONNECTED;
    //   AppStorage.setOrCreate('isConnectedPadCar', isConnectedPadCar);
    //
    //   if (this.enableDc) {
    //     messageChannel.sendMessage('syncAppStorage', { name: 'isConnectedPadCar', value: isConnectedPadCar });
    //     messageChannel.sendMessage('syncAppStorage', { name: 'serviceStateMap', value: this.serviceStateMap });
    //   }
    //   if (result.serviceName === 'PadCarCollaboration-Dual' &&
    //     result.state === collaborationServiceManager.State.CONNECTED) {
    //     let extraInfoObj: CarInfo = {
    //       deviceId: -1,
    //       deviceType: -1,
    //       deviceName: '',
    //       brMac: '',
    //     }
    //     try {
    //       if (result.extraInfo) {
    //         extraInfoObj = JSON.parse(result.extraInfo) as CarInfo;
    //       }
    //     } catch (e) {
    //       extraInfoObj = { deviceId: -1, deviceType: -1, deviceName: '', brMac: '' };
    //       log.showInfo(`parse error ${e.message}`);
    //     }
    //     let padCarInfo: CarInfo =  {
    //       deviceName: extraInfoObj.deviceName,
    //       deviceId: extraInfoObj.deviceId === undefined ? -1 : extraInfoObj.deviceId,
    //       deviceType: extraInfoObj.deviceType === undefined ? -1 : extraInfoObj.deviceType,
    //       brMac: extraInfoObj.brMac,
    //     };
    //      AppStorage.setOrCreate('carInfo', padCarInfo);
    //     if (this.enableDc) {
    //       messageChannel.sendMessage('syncAppStorage', { name: 'carInfo', value: padCarInfo });
    //     }
    //     AppStorage.setOrCreate('serviceName', result?.serviceName);
    //   } else if (this.serviceStateMap['PadCarCollaboration-Dual'] !== collaborationServiceManager.State.CONNECTED) {
    //     AppStorage.setOrCreate('carInfo', undefined);
    //     if (this.enableDc) {
    //       messageChannel.sendMessage('syncAppStorage', { name: 'carInfo', value: undefined });
    //     }
    //   }
    // }
  };

  setNotificationFromDeviceChange(isNotificationFromDeviceChange: boolean) {
    log.showInfo(`deviceChange:${isNotificationFromDeviceChange}, ${CommonUtils.desensitize(this.sessionProvider?.topSessionId)}`);
    AppStorage.setOrCreate('isNotificationFromDeviceChange', isNotificationFromDeviceChange);
    if (!isNotificationFromDeviceChange && this.sessionProvider?.topSessionId) {
      this.refreshAllInfo(this.sessionProvider?.topSessionId);
    }
  }

  /**
   * 设置通知卡片是否显示
   * @param isMediaNtfShowing
   */
  setNtfShowing(isMediaNtfShowing: boolean) {
    AppStorage.setOrCreate('isMediaNtfShowing', isMediaNtfShowing);
  }

  async getDefaultMediaInfo(sessionId: string) {
    let defaultMediaInfo: ShowingMesTS = {
      musicTitle: false,
      musicAuthor: false,
      musicPic: false,
      mediaPlayerIcon: false,
      playState: 0,
      hasMedia: false,
      validCommands: [],
      // 赋默认值修复视频播放完后未刷新问题
      mediaType: 'audio',
      appName: false,
      skipIntervals: 15,
      musicAssetId: '',
      loopMode:'',
      duration:-1,
    }
    let appIcon = await this.getAppIconInner(this.sessionProvider?.bundleNameMap[sessionId],
      this.sessionProvider?.abilityNameMap[sessionId], 'default');
    if (appIcon) {
      defaultMediaInfo.mediaPlayerIcon = appIcon;
      CardMediaController.controllerCallback(defaultMediaInfo);
    }
    log.showInfo('set app icon done');
  }


  /**
   * 刷新数据
   * @param sessionId
   * @param isStartDefault
   * @param isUpdate
   */
  async refreshAllInfo(sessionId: string, isStartDefault?: boolean, isUpdate?: boolean, forceUpdate?: boolean) {
    log.showInfo(`refreshAllInfo start: ${isStartDefault} | ${isUpdate} | ${sessionId?.length < 10 ? '' :
      (sessionId?.substr(0, 5) + '**' + sessionId?.substr(sessionId?.length - 5))}`);
    const descriptor: AVSessionManager.AVSessionDescriptor =
      this.sessionProvider?.avSessionDescriptorMap[sessionId] as AVSessionManager.AVSessionDescriptor;
    const avSessionController: AVSessionManager.AVSessionController =
      this.sessionProvider?.avSessionControllerMap?.get(sessionId) as AVSessionManager.AVSessionController;
    this.appName = false;
    if (!descriptor) {
      log.showInfo('refreshAllInfo no descriptor clear media, return');
      CardMediaController.controllerCallback({
        musicTitle: false,
        musicAuthor: false,
        musicPic: false,
        mediaPlayerIcon: false,
        playState: 0,
        hasMedia: false,
        validCommands: [],
        mediaType: 'audio',
        appName: false,
        skipIntervals: 15,
        musicAssetId: '',
        loopMode: '',
      });
      return;
    }

    if (sessionId !== this.sessionProvider?.topSessionId) {
      log.showInfo(`current sessionId is not target sessionId , dont refresh default media info, curSessionId:
        ${sessionId.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' + sessionId.substr(sessionId.length - 5))}`);
      return;
    }
    CardMediaController.isVideoLink?.set(false);
    if (this.enableDc) {
      messageChannel.sendMessage('syncAppStorage', {name: 'isVideo', value: false});
    }
    this.getDefaultMediaInfo(sessionId);

    let isVideo: boolean = false;
    isVideo = (descriptor.type === 'video');

    let newAppNames: ShowingBundleTS =
      await this.sessionProvider!.getIconWithOnlyBundle(descriptor.elementName?.bundleName);
    if (!!newAppNames) {
      log.showInfo(`refreshAllInfo newAppNames ${newAppNames.appName}`);
      this.appName = newAppNames.appName as string;
    }
    log.showInfo(`refreshAllInfo isVideo ${isVideo}`);
    CardMediaController.isVideoLink?.set(isVideo);
    if (this.enableDc) {
      messageChannel.sendMessage('syncAppStorage', {name: 'isVideo', value: isVideo});
    }
    this.showingMediaId = descriptor.sessionId;
    this.showingController = avSessionController;
    GlobalContext.getInstance().setObject('showingMediaSessionId', avSessionController);
    // app icon
    if (descriptor?.sessionTag === 'RemoteCast') {
      this.showingAppIcon = false;
    } else {
      this.showingAppIcon = await this.getAppIconInner(descriptor.elementName?.bundleName,
        descriptor.elementName?.abilityName);
    }
    // get meta data
    if (!this.commonInterface) {
      this.commonInterface = new CommonInterface();
    }
    if (this.sessionProvider != undefined) {
      this.commonInterface.init(this.sessionProvider);
    }
    this.setShowingAVSessionListener(descriptor.sessionId, avSessionController, isStartDefault, isUpdate);
    let avMetadata = await this.commonInterface.getAVMetadata(sessionId);
    // 获取ValidCommand
    let validCommand:AVSessionManager.AVControlCommandType[] = []
    try {
      validCommand = await this.commonInterface?.getValidCommandsData(sessionId);
      log.showInfo(`refreshAllInfo ValidCommand ${validCommand}`);
    } catch {
      log.showInfo(`refreshAllInfo ValidCommand err`);
    }
    // get av play back state
    this.showingPlayState = await this.commonInterface.getAVPlaybackState(sessionId);
    log.showInfo(`getMetadata done: ${avMetadata?.title}, play: ${this.showingPlayState.state}`);
    // refresh all info
    let showingMesTemp: ShowingMesTS = {
      musicTitle: avMetadata?.title,
      musicAuthor: CardMediaController.isVideoLink?.get() ? (avMetadata?.subtitle || avMetadata?.artist || false) :
        (avMetadata?.artist || avMetadata?.subtitle || false),
      musicPic: avMetadata?.mediaImage,
      mediaPlayerIcon: this.showingAppIcon,
      playState: this.showingPlayState?.state || 0,
      hasMedia: true,
      validCommands: validCommand || [],
      skipIntervals: (descriptor?.sessionTag === 'RemoteCast' && isVideo) ? 30 : (avMetadata?.skipIntervals || 15),
      mediaType: isVideo ? 'video' : descriptor.type,
      appName: this.appName,
      duration: avMetadata?.duration,
      position: this.showingPlayState.position,
      speed: this.showingPlayState.speed,
      lyric: avMetadata?.lyric,
      musicAssetId: avMetadata?.assetId,
      isFavor: this.showingPlayState.isFavorite,
      loopMode: this.showingPlayState.loopMode,
      displayTags: avMetadata?.displayTags,
      avQueueId: avMetadata?.avQueueId,
      forceUpdate,
    };
    if (!!showingMesTemp.musicPic && typeof showingMesTemp.musicPic === 'object') {
      PixelMapUtil.addName(showingMesTemp.musicPic, 'Media_Control');
    }
    CardMediaController.controllerCallback(showingMesTemp);
    avMetadata.mediaImage = undefined;
  }

  async getAppIconInner(bundleName: string, abilityName: string, from?: string):
                        Promise<string | image.PixelMap | boolean | undefined> {
    log.showInfo(`getBundleInfo bundleName: ${bundleName}, from=${from}`);
    const showBundle: string | image.PixelMap | boolean | undefined =
      await this.sessionProvider?.getShowingBundle(bundleName, abilityName);
    return showBundle;
  }

  /**
   * metadata 数据回调
   * @param data
   * @param type
   * @param extraData
   * @returns
   */
  async doMetaDataChangeCallback(data: AVSessionManager.AVMetadata, type: string,
                                 extraData?: ExtraData): Promise<void> {
    log.showInfo(` doMetaDataChangeCallback in without check loop: ${data?.mediaImage}`);
    let showingMes: ShowingMesTS = {
      // 增加无值时清除上次信息
      musicTitle: data?.title,
      musicAuthor: CardMediaController.isVideoLink?.get() ? (data?.subtitle || data?.artist) :
        (data?.artist || data?.subtitle),
      musicPic: data?.mediaImage,
      hasMedia: true,
      musicAssetId: data?.assetId,
      displayTags: data?.displayTags,
      lyric: data?.lyric,
      duration: data?.duration,
      skipIntervals: data?.skipIntervals,
    }
    if (type === 'locale' && !!extraData) {
      showingMes.validCommands = extraData.validCommands || [];
    } else if (type === 'cast' && !!extraData) {
      showingMes.mediaType = extraData.mediaType || 'audio';
      showingMes.validCommands = extraData.validCommands || [];
    }
    this.showingMesHistoryTitle = showingMes.musicTitle;
    CardMediaController.controllerCallback(showingMes);
    showingMes.musicPic = undefined;
    data.mediaImage = undefined;
  }

  async showDefaultMedia() {
    let sessionList: string[] = [];
    sessionList.push('default');
  }

  /**
   * 冷启动App
   * @param targetSessionId
   * @param isFromSessionCreate
   */
  async startShowingDefaultApp(targetSessionId?: string, isFromSessionCreate?: boolean) {
    const sessionId = targetSessionId || this.sessionProvider?.topSessionId || 'default';
    const isColdStarting: boolean = globalStorage.getBooleanByKey('isColdStarting');
    log.showInfo(`start default app with isFromSessionCreate: ${isFromSessionCreate}, ${sessionId?.length < 10 ? '' :
      (sessionId?.substr(0, 5) + '**' + sessionId?.substr(sessionId?.length - 5))}, ${isColdStarting}`);
    if (sessionId === 'default') {
      log.showInfo('start default app for default, return');
      globalStorage.setBooleanByKey('coldStartAnim', false);
      if (this.enableDc) {
        messageChannel.sendMessage('syncGlobalStorage', { name: 'coldStartAnim', value: false });
      }
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
        log.showInfo(`start default startAVPlayback for ${bundle}`);
        return;
      } catch (err) {
        globalStorage.setBooleanByKey('coldStartAnim', false);
        if (this.enableDc) {
          messageChannel.sendMessage('syncGlobalStorage', { name: 'coldStartAnim', value: false });
        }
        log.error('start default cold start app ,startAVPlayback fail :', err);
      }
    }
    // only get controller and refresh media
    let defaultController: AVSessionManager.AVSessionController | undefined =
      this.sessionProvider?.avSessionControllerMap?.get(sessionId);
    if (!defaultController) {
      log.error('controller get fail');
      globalStorage.setBooleanByKey('isColdStarting', false);
      if (this.enableDc) {
        messageChannel.sendMessage('syncGlobalStorage', { name: 'isColdStarting', value: false });
      }
      return;
    }
    log.showInfo(` get avsession controller done for ${defaultController.sessionId?.length < 10 ? '' :
      (defaultController.sessionId?.substr(0, 5) + '**' +
      defaultController.sessionId?.substr(defaultController.sessionId?.length - 5))}`);
    GlobalContext.getInstance().setObject('ShowingController', defaultController)
    try {
      this.setShowingAVSessionListener(defaultController.sessionId, defaultController);
    } catch (error) {
      log.error('setShowingAVSessionListener error', error);
    }
    globalStorage.setBooleanByKey('isColdStarting', false);
    if (this.enableDc) {
      messageChannel.sendMessage('syncGlobalStorage', { name: 'isColdStarting', value: false });
    }
  }

  async startHistoryApp() {
    log.showInfo(`startHistoryApp begin`);
    let historyInfos: Array<AVSessionManager.AVQueueInfo> | undefined =
      await AVSessionManager.getHistoricalAVQueueInfos(1, 1);
    if (historyInfos.length >= 0) {
      let bundleName: string | undefined = historyInfos[0].bundleName;
      let assetId: string | undefined = historyInfos[0].avQueueId;
      log.showInfo(`startHistoryApp bundleName = ${bundleName}, assetId = ${CommonUtils.getMaskStr(assetId)}`);
      if (bundleName && assetId) {
        await AVSessionManager.startAVPlayback(bundleName, assetId);
        log.showInfo(`startHistoryApp success`);
      }
    }
  }

  playAvQueue(bundleName: string, avQueueId: string) {
    AVSessionManager.startAVPlayback(bundleName, avQueueId).then(() => {
      log.showInfo(`hisAVQueue success to startavplayback,replayAlInfo`);
    }).catch((err: BusinessError) => {
      log.error(`hisAVQueue fail to startavplayback,replayAlInfo--result: ${JSON.stringify(err)}`);
    })
  }

  async onDeviceNotification(sessionId: string) {
    log.showInfo('onDeviceNotification begin');
    if (CardMediaController.mediaTitleLink?.get()) {
      log.showInfo('onDeviceNotification no title');
      return;
    }
    let historyInfos: Array<AVSessionManager.AVQueueInfo> | undefined =
      await AVSessionManager.getHistoricalAVQueueInfos(1, 1);
    let selectInfo: AVSessionManager.AVQueueInfo | undefined = undefined;
    for (let i = 0; i < historyInfos.length; i++) {
      if (historyInfos[i].bundleName === this.sessionProvider?.bundleNameMap[sessionId]) {
        selectInfo = historyInfos[i];
        log.showInfo(`onDeviceNotification selectInfo:` + JSON.stringify(selectInfo));
        break;
      }
    }
    if (selectInfo) {
      try {
        this.showingAppIcon =
          await this.getAppIconInner(selectInfo.bundleName || this.sessionProvider?.bundleNameMap[sessionId],
            this.sessionProvider?.abilityNameMap[sessionId], 'notification');
        log.showInfo('this.showingAppIcon' + this.showingAppIcon);
        this.showingMediaId = sessionId;
        this.showingAssetId = selectInfo?.avQueueId;
        log.showInfo('onDeviceNotification avQueue id :', selectInfo?.avQueueId);
      } catch (err) {
        log.error('onDeviceNotification get app icon by elementName err :', err);
      }
      let showingMesTemp: ShowingMesTS = {
        musicTitle: RECENTLY_PLAYED,
        musicAuthor: selectInfo?.avQueueName,
        musicPic: selectInfo?.avQueueImage,
        mediaPlayerIcon: this.showingAppIcon,
        playState: 0,
        appName: this.appName,
        mediaType: 'audio',
        validCommands: ['play']
      }
      if (typeof showingMesTemp.musicPic == 'string') {
        showingMesTemp.musicPic = await ImageDownloaderUtils.downloadImage(showingMesTemp.musicPic as string);
      }
      CardMediaController.controllerCallback(showingMesTemp);
    }
  }

  /**
   * 从外屏跳转应用
   * @param sessionId
   */
  jumpAppWithScreenLock(sessionId?: string) {
    let curSessionId = sessionId === undefined ?
      this.sessionProvider?.topSessionId || '' : sessionId;
    if (this.enableDc) {
      // 子线程无需调用sControlCenterBaseController
      log.showInfo('SmallFoldOuterScreen jump app');
      globalStorage.setStringByKey('scenesType', 'controlCenter');
      this.startAimApp(curSessionId);
    } else {
      // 主线程调用sControlCenterBaseController
      sControlCenterScreenLockController.handleOnControlCenterWithScreenLock(() => {
        // 解锁后才能拉起
        log.showInfo('SmallFoldOuterScreen jump app');
        globalStorage.setStringByKey('scenesType', 'controlCenter');
        this.startAimApp(curSessionId);
      }, false);
    }
  }

  /**
   * 打开播控二级页面
   * @param isSwitch
   * @param mediaData
   * @param iconInfo
   * @param isLocal
   */
  async jumpInside(isSwitch: boolean, curOutputDev: CurOutputDevTS, iconInfo: audio.DeviceType | undefined,
    isLocal: boolean = true) {
    TraceUtil.startTrace(DomainName.CC, JUMP_MEDIA);
    // 性能打点，进入播控
    performanceMonitor.begin('INTO_CC_MEDIA_ANI', performanceMonitor.ActionType.LAST_UP);
    let bundleName: string = 'com.ohos.mediacontroller';
    let abilityName: string = 'MainAbility';
    let want: Want = {
      bundleName: bundleName,
      abilityName: abilityName,
      parameters: {
        message: isSwitch ? 'switch' : '',
        iconInfo: iconInfo || 1000,
        isLocal: isLocal,
        isVideo : (CardMediaController.mediaTypeLink?.get() === 'video'),
        statusBarType: DeviceHelper.isPC() ? AppStorage.get('statusBarType') as number : '',
        pivotX: this.getAnimPivotX(PluginSlot.SLOT_STATUS_CONTROL_CENTER),
        pivotY: this.getAnimPivotY(PluginSlot.SLOT_STATUS_CONTROL_CENTER),
      }
    }

    let curCallDev: CurOutputDevTS | undefined = AppStorage.get('curCallDev');
    let callItem: LocalDeviceInfo | undefined = undefined;
    if (curCallDev) {
      callItem = {
        deviceId: curCallDev.deviceId,
        deviceType: curCallDev.deviceType,
        deviceSource: DeviceSource.LOCAL,
        deviceAddress: curCallDev.deviceAddress,
        networkId: curCallDev.networkId,
      }
      AppStorage.setOrCreate('curCallDevice', callItem);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', { name: 'curCallDevice', value: callItem});
      }
    }

    let item: LocalDeviceInfo = {
      deviceId: curOutputDev.deviceId,
      deviceType: audio.DeviceType.SPEAKER,
      deviceName: this.localDeviceName,
      deviceIcon: $r(AVCastPickerDeviceIconName.PHONE_SYMBOL),
      deviceSource: DeviceSource.LOCAL,
      deviceState: 2,
      isLocal: true,
    }
    if (isLocal && curOutputDev.deviceType === audio.DeviceType.SPEAKER) {
      AppStorage.setOrCreate('CurDeviceSelect', {
        deviceId: curOutputDev.deviceId,
        deviceType: audio.DeviceType.SPEAKER,
        deviceName: curOutputDev.networkId !== 'LocalDevice' ? '' : 'xxx',
        deviceSource: DeviceSource.LOCAL,
        networkId: curOutputDev.networkId
      });
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', { name: 'CurDeviceSelect', value: {
          deviceId: curOutputDev.deviceId,
          deviceType: audio.DeviceType.SPEAKER,
          deviceName: curOutputDev.networkId !== 'LocalDevice' ? '' : 'xxx',
          deviceSource: DeviceSource.LOCAL,
          networkId: curOutputDev.networkId,
        }});
      }
    } else {
      AppStorage.setOrCreate('CurDeviceSelect', {
        deviceId: curOutputDev.deviceId,
        deviceType: iconInfo,
        deviceAddress: curOutputDev.deviceAddress,
        deviceSource: isLocal ? DeviceSource.LOCAL : DeviceSource.CAST,
        networkId: curOutputDev.networkId
      });
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', { name: 'CurDeviceSelect', value: {
          deviceId: curOutputDev.deviceId,
          deviceType: iconInfo,
          deviceAddress: curOutputDev.deviceAddress,
          deviceSource: isLocal ? DeviceSource.LOCAL : DeviceSource.CAST,
          networkId: curOutputDev.networkId,
        }});
      }
      item.deviceState = 0;
    }
    let hasCall: boolean | undefined = AppStorage.get('hasCall');
    AppStorage.setOrCreate('LocalDeviceItem', hasCall ? callItem : item);
    if (this.enableDc) {
      messageChannel.sendMessage('syncAppStorage', { name: 'LocalDeviceItem', value: hasCall ? callItem : item });
    }
    let enableUnification: boolean = systemParameterEnhance.getSync('mediaController.unification', 'true') == 'true'
    if (DeviceHelper.isPC() && !ControlCenterPluginMgr.isPcMode) {
      sEventManager.publish(obtainLocalEvent('hideControlPanel', ''));
      StartAbilityUtil.startServiceExtensionAbility(want);
    } else {
      this.goSubWindow(want, enableUnification);
    }
    TraceUtil.endTrace(DomainName.CC, JUMP_MEDIA);
  }

  /**
   * 将缩放值转为字符串形式百分数
   * @param value 缩放比
   * @returns
   */
  toPercentage(value: number): string {
    value = value > 1 ? 1 : value;
    value = value < 0 ? 0 : value;
    return `${(value * 100).toFixed(0)}%`;
  }

  /**
   * 获取锚点信息，X轴上位置
   * @param windowName 窗口名
   * @returns
   */
  getAnimPivotX(windowName: string) {
    let pivotX: number = windowMgr.getWindowAnimPivot(windowName)[0] ?? 0;
    return this.toPercentage(pivotX);
  }

  /**
   * 获取锚点信息，y轴上位置
   * @param windowName 窗口名
   * @returns
   */
  getAnimPivotY(windowName: string) {
    let pivotY: number = windowMgr.getWindowAnimPivot(windowName)[1] ?? 0;
    return this.toPercentage(pivotY);
  }

  async startAimApp(sessionId: string) {
    let hasCall: boolean | undefined = AppStorage.get('hasCall');
    if (!sessionId && !hasCall) {
      return;
    }
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
      this.reportUE(EventType.JUMP_APP, 'INVALID_BUNDLENAME_ABILITYNAME', true);
      return;
    }
    try {
      this.startLaunchAbility(want, sessionId, wantAgent);
      log.showInfo(' startAimApp to quit');
    } catch (err) {
      log.warn(` startAimApp err : ${err}`);
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
          this.reportUE(EventType.JUMP_APP, 'SUCCESS', true);
        });
      } else {
        log.showInfo(`startAbility successful.start: ${JSON.stringify(want)}`);
        this.context?.startAbility(want).then(async (data) => {
          log.showInfo('startAbility successful.');
          this.reportUE(EventType.JUMP_APP, 'SUCCESS', true);
        }).catch((error : BusinessError) => {
          log.error('startAbility failed. Cause: ' + JSON.stringify(error));
          this.reportUE(EventType.JUMP_APP, error.message, true);
          const dfxParam : DfxParam = { PACKAGE_NAME : want.bundleName, REASON: error.message, OPERATE_TYPE: 'JUMP_APP' };
          this.sessionProvider?.reportScenesHiEvent(EventType.JUMP_APP_FAIL, dfxParam, false);
        })
        log.showInfo('startAbility successful. end');
      }
      CommunicationUtil.prepareExitState = 'jump';
      CommunicationUtil.doRemoteEventNotify();
    } catch (err) {
      log.error(`startLaunchAbility err: ${err.message}`);
      this.reportUE(EventType.JUMP_APP, err.message, true);
      const dfxParam : DfxParam = { PACKAGE_NAME : want.bundleName, REASON: err.message, OPERATE_TYPE: 'JUMP_APP' };
      this.sessionProvider?.reportScenesHiEvent(EventType.JUMP_APP_FAIL, dfxParam, false);
    }
  }

  doSubscribeNotify() {
    if (this.unsubscribe) {
      return;
    }
    log.showInfo('do Subscribe in at first time.');
    this.dropDownTimeStamp = new Date().getTime();
    /**
     * 监听双中心状态变化，0=收起，1=通知中心，2=控制中心
     */
    this.unsubscribe = sEventManager.subscribe('mediaPanelStateChange', async (targetPanel: TargetPanel) => {
      let isMediaNtfShowing: boolean | undefined = AppStorage.get('isMediaNtfShowing');
      log.showInfo(`drop down event, target: ${targetPanel}, ntr=${isMediaNtfShowing}, ${this.needRefreshOnDropdown}`);
      AppStorage.setOrCreate('mediaPanelState', targetPanel);
      if (this.enableDc) {
        messageChannel.sendMessage('syncAppStorage', { name: 'mediaPanelState', value: targetPanel });
      }
      if (targetPanel === TargetPanel.NONE) {
        this.needRefreshOnDropdown = true;
        log.showInfo(`drop up event: restore need refresh state`);
        return;
      }
      if (!this.needRefreshOnDropdown) {
        log.showInfo(`drop down event: already refreshed`);
        return;
      }
      if (targetPanel === TargetPanel.NOTIFICATION_PANEL && !isMediaNtfShowing) {
        log.showInfo(`drop down event: ntf center without media ntf`);
        return;
      }
      this.needRefreshOnDropdown = false;
      this.doRefreshOnDropdown();
    });
    /**
     * 监听下拉事件，兼容PC场景
     */
    this.unsubscribe = sEventManager.subscribe('DropdownEvent', (isExpand: boolean) => {
      if (isExpand && DeviceHelper.isPC()) {
        this.doRefreshOnDropdown();
      }
    });
    sEventManager.publish(obtainLocalEvent('MediaCardRefreshEvent', true));
  }

  /**
   * 下拉事件广播
   * @param targetPanel
   */
  panelStateChange(targetPanel: TargetPanel) {
    sEventManager.publish(obtainLocalEvent('mediaPanelStateChange', targetPanel));
  }

  doRefreshOnDropdown(): void {
    // 控制中心下滑事件判断依据的是Y轴方向上的偏移，下滑时会触发多次，通过时间戳防止多次回调
    let newDropDownTimeStamp = new Date().getTime();
    log.showInfo(`drop down newDropDownTimeStamp: ${newDropDownTimeStamp} | ${this.dropDownTimeStamp}`);
    this.isShowingMesHistory = true;
    if ((newDropDownTimeStamp > this.dropDownTimeStamp) &&
      (newDropDownTimeStamp - this.dropDownTimeStamp) < this.DROPDOWN_CALLBACK_INTERVAL) {
      log.error(' drop down callback too much.');
      return;
    }
    sEventManager.publish(obtainLocalEvent('MediaCardShowing', true));
    this.dropDownTimeStamp = new Date().getTime();
    if (this.showingController) {
      try {
        this.showingController = undefined;
      } catch (err) {
        log.error('do session controller release fail:', err);
      }
      this.showingController = undefined;
    }
    setTimeout(async () => {
      this.startShowing(TAG);
      sEventManager.publish(obtainLocalEvent('MediaCardRefreshEvent', true));
    }, 0);
    MediaInfoProvider.getInstance().isExistAvQueueStateUpdate();
  }

  private async updateWhenDropdown() {

  }

  release(needRemoveSubscriber = true) {
    log.showInfo(`task release with subscriber: ${needRemoveSubscriber}`);
    SessionInfoProvider.off('sessionChanged', this.getSessionChangeCallback());
    SessionInfoProvider.off('topSessionChangeHis', this.getTopSessionChangeCallback())
    SessionInfoProvider.off('deviceNotification', this.getDeviceNotificationCallback());
    SessionInfoProvider.off('controllerChanged', this.getControllerChangeCallback());
    SessionInfoProvider.off('sessionDestroy', this.getSessionDestroyCallback());
    // collaborationServiceManager.unsubscribeServiceState();
    this.commonInterface?.release();
    if (this.showingController) {
      this.showingController = undefined;
      GlobalContext.getInstance().removeObject('showingMediaSessionId')
    }
    this.sessionProvider?.release();
    if (needRemoveSubscriber) {
      this.unsubscribe && this.unsubscribe();
      this.unsubscribe = undefined;
    }
    if (this.enableDc) {
      messageChannel.offMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, this.callByWorker); // 监听子线程消息
    }
    try {
      CommonEventManager.unsubscribe(this.commonEventSubscriber);
      this.commonEventSubscriber = null;
    } catch (e) {
      log.showError(`common event unsubscribe fail catch error: ${e?.message}`);
    }
  }

  private goSubWindow(want: Want, enableUnification: boolean): void {
    log.showInfo(`goSubWindow with enableUnification: ${enableUnification}`);
    if (!enableUnification) {
      // 跳转播控二级界面 隐藏控制中心元素
      sControlCenterScreenLockController.handleOnControlCenterWithScreenLock(() => {
        // 解锁后才能拉起
        StartAbilityUtil.startServiceExtensionAbility(want);
        GlobalContext.getInstance().setObject('isMediaCenterShow', true);
        sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.SUB_PANEL));
        this.release();
      }, false);
    } else if (this.enableDc) {
      // 子线程无需调用sControlCenterBaseController
      CardMediaController.showingWant = want;
      GlobalContext.getInstance().setObject('isMediaCenterShow', true);
      AppStorage.setOrCreate('showDmModal', false);
      messageChannel.sendMessage('syncAppStorage', { name: 'showDmModal', value: false });
      messageChannel.sendMessage('goSubWindow', want);
      MediaInfoProvider.getInstance();
    } else {
      // 跳转播控二级界面 隐藏控制中心元素
      sControlCenterScreenLockController.handleOnControlCenterWithScreenLock(() => {
        // 解锁后才能拉起
        CardMediaController.showingWant = want;
        GlobalContext.getInstance().setObject('isMediaCenterShow', true);
        AppStorage.setOrCreate('showDmModal', false);
        sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MEDIA_CENTER));
      }, false);
    }
  }

  closeSubWindow() {
    GlobalContext.getInstance().setObject('isMediaCenterShow', false);
    sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MAIN_LAYOUT));
  }

  /**
   * 关闭播控
   */
  jumpOutside() {
    if (!DeviceHelper.isPC() || ControlCenterPluginMgr.isPcMode) {
      CommunicationUtil.prepareExitState = 'quit';
      CommunicationUtil.doRemoteEventNotify();
    }
  }

  public postNotificationCancelEvent(notifyId: string, from?: string): void {
    log.showInfo('post Notification Cancel Event notifyId: ' + notifyId + ', type: ' + from);
    let reason = notificationSubscribe.RemoveReason.CANCEL_REASON_REMOVE;
    try {
      notificationSubscribe.remove(notifyId, reason, (err) => {
        if (err) {
          log.showError(`remove failed, code is ${err.code}, message is ${err.message}`);
        } else {
          log.showInfo('remove success');
        }
      });
    } catch (error) {
      log.showError('postNotificationCancelEvent error ' + error);
    }
    log.showInfo('postNotificationCancelEvent done');
  }

  public removeExistedNotification(notifyId: string, forceRemove: boolean = false): void {
    if (forceRemove) {
      log.showInfo('removeExistedNotification forceRemove')
      this.postNotificationCancelEvent(notifyId, 'remove forced');
      CardMediaController.lastNotifyId = '';
      return;
    }
    log.showInfo('removeExistedNotification: ' + notifyId + ', lastNotifyId: ' + CardMediaController.lastNotifyId);
    if (notifyId !== CardMediaController.lastNotifyId && CardMediaController.lastNotifyId != '') {
      this.postNotificationCancelEvent(CardMediaController.lastNotifyId, 'remove existed');
    }
    CardMediaController.lastNotifyId = notifyId;
  }

  private startRemoveNotificationTimer = debounce(async () => {
    log.showInfo('start a new timer when there is no music play, time: ' + new Date().getTime());
    let timerId: number;
    const options: systemTimer.TimerOptions = {
      type: systemTimer.TIMER_TYPE_WAKEUP | systemTimer.TIMER_TYPE_EXACT,
      repeat: false,
      callback: async () => {
        try {
          const playbackState = await this.commonInterface?.getAVPlaybackState(this.playingSessionId);
          const isPlaying = playbackState?.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY ||
            playbackState?.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING;
          if (isPlaying || !playbackState) {
            log.showInfo(`current session is playing donot remove, state: ${playbackState?.state}`);
            return;
          }
        } catch (e) {
          let error: BusinessError = e as BusinessError;
          log.showWarn(`getAVPlaybackState failed, message: ${error.message}, code: ${error.code}`);
        }
        // 处理定时器注销失败而实际可能没有销毁的情况
        if (!this.removeNotificationTimer || this.removeNotificationTimer !== timerId) {
          log.showInfo(`self system timer had released, self timerId: ${timerId},
              current timerId: ${this.removeNotificationTimer}`);
          return;
        }
        this.postNotificationCancelEvent(CardMediaController.lastNotifyId, '10 minutes');
        this.removeNotificationTimer = undefined;
      }
    }
    await this.clearRemoveNotificationTimer();
    try {
      // 创建系统定时器
      timerId = await systemTimer.createTimer(options);
      this.removeNotificationTimer = timerId;
      const endTime = new Date().getTime() + REMOVE_NOTIFICATION_TIME;
      await systemTimer.startTimer(this.removeNotificationTimer, endTime);
      log.showInfo(`Start system timer success, timerId: ${this.removeNotificationTimer}`);
    } catch (e) {
      // 创建或者启动定时器失败
      let error: BusinessError = e as BusinessError;
      log.showWarn(`Start system timer failed, message: ${error.message}, code: ${error.code}`);
    }
  }, 500)

  private async clearRemoveNotificationTimer() {
    if (this.removeNotificationTimer === undefined) {
      return;
    }
    try {
      log.showInfo(`start destroy system timer, timerId: ${this.removeNotificationTimer}`)
      await systemTimer.destroyTimer(this.removeNotificationTimer)
      log.showInfo('destroy system timer success, timerId: ' + this.removeNotificationTimer)
      this.removeNotificationTimer = undefined;
    } catch (e) {
      let error: BusinessError = e as BusinessError;
      log.showWarn(`destroy system timer failed, message: ${error.message}, code: ${error.code}`);
      this.removeNotificationTimer = undefined;
    }
  }

  getDeviceNotificationCallback(): LocalEventCallback {
    if (!this.deviceNotificationCallback) {
      this.deviceNotificationCallback = new LocalEventCallback((sessionId: string) => {
        log.showInfo(` deviceNotification to refresh: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
          sessionId?.substr(sessionId?.length - 5))}`);
        this.onDeviceNotification(sessionId);
      });
    }
    return this.deviceNotificationCallback;
  }

  getControllerChangeCallback(): LocalEventCallback {
    if (!this.controllerChangeCallback) {
      this.controllerChangeCallback = new LocalEventCallback((sessionId: string) => {
        log.showInfo(` controllerChanged to refresh: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
          sessionId?.substr(sessionId?.length - 5))}`);
        this.refreshAllInfo(sessionId, false, true);
      });
    }
    return this.controllerChangeCallback;
  }

  getTopSessionChangeCallback(): LocalEventCallback {
    if (!this.topSessionChangeCallback) {
      this.topSessionChangeCallback = new LocalEventCallback((sessionId: string) => {
        this.playingSessionId = sessionId;
        this.clearRemoveNotificationTimer();
        log.showInfo(` top session changed to: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
          sessionId?.substr(sessionId?.length - 5))}`);
        let avSessionController: AVSessionManager.AVSessionController =
          this.sessionProvider?.avSessionControllerMap?.get(sessionId) as AVSessionManager.AVSessionController;
        this.setShowingAVSessionListener(sessionId, avSessionController);
      });
    }
    return this.topSessionChangeCallback;
  }

  /**
   * 设备是否亮屏
   */
  isPowerActive(): boolean {
    try {
      return power.isActive();
    } catch (err) {
      log.showError(`check active status failed, err: ${err?.code}, ${err?.message}`);
    }
    return false;
  }

  /**
   * 上报设备日志
   * @param curSessionId
   * @param startTime
   */
  reportExpandShowDeviceList(curSessionId: string, startTime: number) {
    SessionInfoProvider.getInstance().then((provider: SessionInfoProvider) => {
      let avType: AVSessionManager.AVSessionType | undefined =
        provider.avSessionDescriptorMap[curSessionId]?.type;
      if (!avType) {
        return;
      }
      log.showInfo(TAG, `reportShowDeviceList-type = ${avType}`);
      let sessionId: string = provider?.sessionListCache[0] as string;
      let bundleName: string = provider?.bundleNameMap[sessionId] as string;
      let dfxParam: DfxParam = {
        TIME_COST: new Date().getTime() - startTime,
        APP_TYPE: avType.toString(),
        PACKAGE_NAME: bundleName,
        PNAMEID: this.pInfoName,
        PVERSIONID: this.pInfoVersion,
        TIME: new Date().getTime(),
        CONTROLINTERFACE: globalStorage.getNumberByKey('isShowSwitch'),
        SCREENSTATUS: this.getScreenStatus(),
        DEVICEMODELTYPE: 'phone',
        SCREENFOLDEDSTATUS: CommonUtils.isFoldExpanded() ? (CommonUtils.isUltraScreenProductInGState() ? 11 : 1) : 2,
        PICKER_STYLE: 'NONE'
      };
      provider.reportScenesHiEvent(EventType.SHOW_DEVICE_LIST, dfxParam, true);
    });
  }
}

class CommonInterface {
  public sessionProvider: SessionInfoProvider | undefined = undefined;
  private lastAssetId: string = '';
  private lastTitle: string | undefined = '';
  private lastMediaImage: Map<string, image.PixelMap | string | undefined> = new Map();
  private playStateLocalCallbackMap:Map<string, playbackStateChangeType | undefined> = new Map();
  private playStateCastCallbackMap:Map<string, playbackStateChangeType | undefined> = new Map();
  private metadataCallbackMap: Map<string, MetadataChangeCallback> = new Map();
  private validCommandCallbackMap: Map<string, ValidCommandChangeCallback> = new Map();
  private curAssetId: string = '';
  private curBundleName: string = '';

  init(provider: SessionInfoProvider) {
    this.sessionProvider = provider;
  }

  release() {
    this.playStateLocalCallbackMap.clear();
    this.playStateCastCallbackMap.clear();
  }

  public getCurrentController(sessionId: string): GetCurrentControllerTS {
    if (!this.sessionProvider) {
      log.error(' getCurrentController pick null ');
      return { controller: null, type: '' };
    }
    log.debug(' getCurrentController pick local ');
    return {
      type: 'local',
      controller: this.sessionProvider.avSessionControllerMap.get(sessionId),
    };
  }

  public async getValidCommandsData(sessionId: string): Promise<AVSessionManager.AVControlCommandType[]> {
    log.showInfo(`getValidCommandsData begine`);
    const controllerStruct = await this.getCurrentController(sessionId);
    let controller = controllerStruct.controller;
    let type = controllerStruct.type;
    const commands = await (controller as AVSessionManager.AVSessionController).getValidCommands();
    log.showInfo(`getValidCommandsData local: ${JSON.stringify(commands)}`);
    return commands as Array<AVSessionManager.AVControlCommandType>;
  }

  /**
   * 获取metadata数据
   * @param sessionId
   * @returns
   */
  public async getAVMetadata(sessionId: string): Promise<MetadataTS> {
    log.showInfo(`getAVMetadata in commonInterface in `);
    const controllerStruct = this.getCurrentController(sessionId);
    let controller = controllerStruct.controller;
    let type = controllerStruct.type;
    if (!controller) {
      log.error(`fail to send cast control command: no controller found`);
      return {} as MetadataTS;
    }
    log.debug(`try get av meta data: ${type}, ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
    if (type === 'local') {
      let getAVLocalMetadata = (controller as AVSessionManager.AVSessionController).getAVMetadata();
      log.showInfo(`getAVLocalMetadata: ${JSON.stringify(getAVLocalMetadata)}`)
      return getAVLocalMetadata;
    } else {
      let metadata = {} as AVSessionManager.AVMetadata;
      let error: string = '';
      const avController = this.sessionProvider?.avSessionControllerMap.get(sessionId);
      const localData = await avController?.getAVMetadata();
      if (localData && localData?.skipIntervals !== undefined) {
        log.showInfo(`use skipIntervals from local: ${localData.skipIntervals}`);
        metadata.skipIntervals = localData.skipIntervals;
      }
      if (error || !metadata?.assetId) {
        log.error(`get av meta fail: ${error}.`);
        return Promise.reject(error || metadata);
      }
      if (metadata.mediaImage) {
        return Promise.resolve(metadata);
      }
      log.showWarn(`no media image found in av meta data, try get it from avsession`);
      if (localData && localData?.assetId === metadata.assetId && localData?.mediaImage) {
        log.debug('found media image from avsession');
        metadata.mediaImage = localData?.mediaImage;
      }
      return Promise.resolve(metadata);
    }
  }

  /**
   * metadata数据变化回调
   * @param sessionController
   * @param isUpdate
   * @param callback
   */
  onMetadataChange(sessionController: AVSessionManager.AVSessionController, isUpdate: boolean, callback: Function) {
    log.showInfo(`get in metadatachange with ${sessionController?.sessionId?.length < 10 ? '' :
      (sessionController?.sessionId?.substr(0, 5) + '**' +
      sessionController?.sessionId?.substr(sessionController?.sessionId?.length - 5))}, ${isUpdate}`);
    if (!sessionController) {
      log.error(`get av Metadata change with no sessionController`);
      return;
    }
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
    sessionController.getAVMetadata().then((metadata) => {
      log.showInfo(` onMetadataChange getAVMetadata: ${metadata.title}`)
      callback(metadata, 'locale');
    });
    if (!this.sessionProvider) {
      log.error(`mediaItemChange with no cast `);
      return;
    }
  }

  async onMediaItemChange(data: AVSessionManager.AVQueueItem, callback: Function, sessionId: string): Promise<void> {
    const description = data.description;
    this.curBundleName = this.sessionProvider?.bundleNameMap[sessionId];
    if (!description) {
      callback({} as AVSessionManager.AVMetadata, 'cast');
      return;
    }
    this.curAssetId = description.assetId;
    const param: RadarParam = {
      ORG_PKG: 'ohos.mediacontroller',
      TO_CALL_PKG: 'av_session',
      TRIGGER_MODE: AppStorage.get('selectMode') === 'checkbox' ?
        TriggerMode.mediaDeviceListCast : TriggerMode.appComponentCast,
      FUNC: 'castPlayStateCallback',
      BIZ_SCENE: BizScene.startCast,
      BIZ_STAGE: StartCAST.sinkPlay,
      STAGE_RES: StageResult.sussess,
      BIZ_STATE: BizState.ending,
      APP_CALLER: this.curBundleName,
      RESOURCE_TYPE: description.mediaType,
      RESOURCE_DURATION: description.duration
    };
    this.sessionProvider?.reportScenesHiEvent(EventType.MEDIA_CONTROL_CAST_BEHAVIOR, param, false);
    let situation: number = -1;
    const result = {
      title: description.title,
      subtitle: description.subtitle,
      artist: description.artist,
      duration: description.duration,
      lyric: '',
    } as AVSessionManager.AVMetadata;
    if (description.mediaImage || description.albumCoverUri) {
      this.lastAssetId = description.assetId;
      this.lastTitle = description.title;
      let mediaImage: image.PixelMap | string | undefined = description.mediaImage || description.albumCoverUri;
      if (typeof mediaImage === 'string') {
        mediaImage = await ImageDownloaderUtils.downloadImage(mediaImage as string);
      }
      this.lastMediaImage.clear();
      this.lastMediaImage.set(description.assetId, mediaImage);
      result.mediaImage = mediaImage;
      situation = 1;
    } else if (this.lastAssetId !== description.assetId || this.lastTitle !== description.title) {
      log.showInfo('mediaItemChange has no image but diff song');
      result.mediaImage = description.mediaImage || description.albumCoverUri;
      if (typeof result.mediaImage === 'string') {
        result.mediaImage = await ImageDownloaderUtils.downloadImage(result.mediaImage as string);
      }
      this.lastAssetId = description.assetId;
      this.lastTitle = description.title;
      situation = 0;
    } else {
      return;
    }
    // 投播场景，主动获取validCommand
    let validCommand: AVSessionManager.AVControlCommandType[] = await this.getValidCommandsData(sessionId);
    log.showInfo(`getAVMetadata ValidCommand: ${JSON.stringify(validCommand)}`)
    let castMediaType = (description.mediaType || 'audio').toLowerCase();
    let extraData: ExtraData = {
      mediaType: castMediaType as AVSessionManager.AVSessionType,
      validCommands: validCommand || []
    }
    if (situation === 0 && this.lastMediaImage.has(description.assetId)) {
      log.showInfo( `mediaItemChange get stored image`);
      result.mediaImage = this.lastMediaImage.get(description.assetId);
      this.lastMediaImage.clear();
    }
    callback(result, 'cast', extraData);
  }

  /**
   * ValidCommands数据变化回调
   * @param sessionController
   * @param isUpdate
   * @returns callback
   */
  onValidCommandChange(avSessionController: AVSessionManager.AVSessionController,
                       isUpdate: boolean, callback: Function) {
    log.showInfo(`onValidCommandChange begin`);
    if (!avSessionController) {
      log.error(`onValidCommandChange fail to send cast control command: no controller found`);
      callback([] as Array<AVSessionManager.AVControlCommandType>, '');
    }
    const sessionId = avSessionController.sessionId;
    if (!isUpdate) {
      if (!this.validCommandCallbackMap.has(sessionId)) {
        let validCommandCallback = new ValidCommandChangeCallback((event: ValidCommandChangeEvent) => {
          log.showInfo(`onValidCommandChange local changing`);
        }, sessionId);
        this.validCommandCallbackMap.set(sessionId, validCommandCallback);
        MediaEventManager.registerEventListener(MediaEventType.VALID_COMMAND_CHANGE, validCommandCallback);
      }
    } else {
      log.showInfo(`onValidCommandChange already have`);
    }
    if (!this.sessionProvider) {
      log.error(`onValidCommandChange with no cast`);
      return;
    }
  }

  /**
   * 发送指令
   * @param sessionId
   * @param command
   * @returns
   */
  public async sendControlCommand(sessionId: string | undefined, command: AVSessionManager.AVControlCommand):
    Promise<void> {
    log.debug(`try send common control command: ${!!sessionId}`);
    const controllerStruct = this.getCurrentController(sessionId as string);
    let controller = controllerStruct.controller;
    if (!controller) {
      log.error(`fail to send cast control command: no controller found`);
      return;
    }

    return (controller as AVSessionManager.AVSessionController).sendControlCommand(command);
  }

  /**
   * 获取当前播放状态
   * @param sessionId
   * @returns
   */
  async getAVPlaybackState(sessionId: string): Promise<AVSessionManager.AVPlaybackState> {
    const controllerStruct = this.getCurrentController(sessionId);
    let controller = controllerStruct.controller;
    let type = controllerStruct.type;
    if (!controller) {
      log.error(`fail to get av playback state: no controller found`);
      return Promise.reject();
    }
    let avPlayState: AVSessionManager.AVPlaybackState = await controller.getAVPlaybackState();
    log.debug(` get av playback state ${JSON.stringify(avPlayState)} | ${avPlayState.state}`);
    return avPlayState;
  }

  /**
   * 播放状态回调
   * @param sessionController
   * @param isUpdate
   * @param callback
   */
  onPlaybackStateChanged(sessionController: AVSessionManager.AVSessionController, isUpdate: boolean,
    callback: Function) {
    log.debug(`get in playbackstatechange with ${JSON.stringify(sessionController)}}, ${isUpdate}`);
    let playbackLocalList: playbackStateChangeType | undefined =
      this.playStateLocalCallbackMap.get(sessionController.sessionId);
    if (!isUpdate) {
      if (playbackLocalList !== undefined) {
        sessionController.off('playbackStateChange', playbackLocalList);
        this.playStateLocalCallbackMap.delete(sessionController.sessionId);
      }
      let playbackStateLocalCallback = (state: AVSessionManager.AVPlaybackState) => {
        callback(state);
      }
      sessionController.on('playbackStateChange', 'all', playbackStateLocalCallback);
      this.playStateLocalCallbackMap.set(sessionController.sessionId, playbackStateLocalCallback);
    }
    if (!sessionController) {
      log.error(`get av playback state change with no sessionController`);
      return;
    }
    const sessionId = sessionController.sessionId;
    if (!this.sessionProvider) {
      log.error(`playbackStateChange with no cast `);
      return;
    }
    let playbackCastList: playbackStateChangeType | undefined =
      this.playStateCastCallbackMap.get(sessionController.sessionId);
    if (playbackCastList !== undefined) {
      this.playStateCastCallbackMap.delete(sessionController.sessionId);
    }
    let playbackStateCastCallback = (state: AVSessionManager.AVPlaybackState) => {
    }
    this.playStateCastCallbackMap.set(sessionController.sessionId, playbackStateCastCallback);
  }

  releaseCallback(sessionId: string) {
    let metadataCallback: MediaEventCallback | undefined = this.metadataCallbackMap.get(sessionId);
    if (metadataCallback != undefined) {
      this.metadataCallbackMap.delete(sessionId);
      MediaEventManager.unRegisterEventListener(MediaEventType.METADATA_CHANGE, metadataCallback);
    }
    let validCommandCallback: ValidCommandChangeCallback | undefined = this.validCommandCallbackMap.get(sessionId);
    if (validCommandCallback != undefined) {
      this.validCommandCallbackMap.delete(sessionId);
      MediaEventManager.unRegisterEventListener(MediaEventType.VALID_COMMAND_CHANGE, validCommandCallback);
    }
    if (this.playStateLocalCallbackMap.get(sessionId)) {
      this.playStateLocalCallbackMap.delete(sessionId);
    }
    if (this.playStateCastCallbackMap.get(sessionId)) {
      this.playStateCastCallbackMap.delete(sessionId);
    }
    this.sessionProvider?.avSessionControllerMap.get(sessionId)?.off('playbackStateChange');
  }
}