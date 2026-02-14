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

import {
  AnimateToScheduleUtils,
  CheckEmptyUtils,
  CommonUtils,
  DomainName,
  LogHelper,
  RectInfo,
  SplitStatus,
  StartType,
  TraceUtil,
  WindowPanelType
} from '@ohos/basicutils';
import {
  ActiveReason,
  ControlType,
  ExecuteCallbackExtraInfo,
  FocusChangeReason,
  INVALID_SCREEN_ID,
  PreferenceStore,
  SCBEventId,
  ScbNumber,
  SCBRecoverManager,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneMemoryInfo,
  SCBSceneMode,
  SCBSceneOrientation,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSessionEventId,
  SCBSessionRect,
  SCBSpecificSceneSessionList,
  SCBSpecificSession,
  SCBSystemSceneSession,
  SCBTransitionController,
  SCBTransitionManager,
  SCBWindowRaiseReason,
  ScenePanelState,
  SessionChangeInfo,
  SessionDisplayChangeReason,
  sSCBOobeManager,
  SystemBarType,
  WindowDragHotAreaType,
  WinLog,
  WinLogDomain
} from '@ohos/windowscene';
import { IAnimationPolicy } from '../animation/IAnimationPolicy';
import { SceneAnimationPolicy } from '../animation/SceneAnimationPolicy';
import {
  DEFAULT_RATIO,
  HALF,
  InitPosType,
  INVALID_DPI,
  INVALID_POSITION,
  MINI_VALUE,
  PolicyType,
  ViewModelConstant,
  RealScreenInfo,
  ScreenForm,
  SMARTDOCK_APPICON_CONTAINER,
  WindowSizeLimits,
  WindowSizeResult,
  WINDOW_AVOIDANCE,
  WINDOW_INTERVAL,
  ExitSplitParam,
  MonitorExitSplitName,
} from '../constants/BaseConstants';
import { IBase } from '../base/IBase';
import { LogUtil } from '../utils/LogUtil';
import { ILayoutPolicy } from '../layout/ILayoutPolicy';
import { LayoutPolicy } from '../layout/LayoutPolicy';
import { ILifecyclePolicy } from '../lifecycle/ILifecyclePolicy';
import { LifecyclePolicy } from '../lifecycle/LifecyclePolicy';
import { IFreeWindowsViewModel } from './IFreeWindowsViewModel';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { PcSCBSceneContainerSessionArray, SCBSessionListManager } from '../instance/SCBSessionListManager';
import {
  settingsDataManager,
  ApsUtils,
  HiSysEventUtil,
  localEventManager,
  SCBWindowSceneConfig,
  ViewArea,
  ViewCallback,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { systemDateTime } from '@kit.BasicServicesKit';
import { multiInputManager, MultiInputViewModel } from '@ohos/multiinput';
import { SCBSystemSceneUtils } from '../utils/SCBSystemSceneUtils';
import { UIContext } from '@kit.ArkUI';
import { SCBSceneHelper } from '../utils/SCBSceneHelper';
import {
  AppItemInfo,
  CommonConstants,
  DockItemInfo,
  EventConstants,
  KeyConstants,
  PageDesktopModel,
  RecentBundleMissionInfo,
  StyleConstants,
  CloseAppManager,
  StartSubtype,
  AppModel,
  ResidentLayoutCacheMgr,
  LayoutViewModel
} from '@ohos/launchercommon';
import { SCBPcScenePanelManager } from '../instance/SCBPcScenePanelManager';
import { AbilityConstant, bundleManager } from '@kit.AbilityKit';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import display from '@ohos.display';
import { PcDockIndepentIconMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockIndependentIconMgr';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { systemAniSceneCtrl } from '../utils/SystemAnimatedSceneController';
import { SystemAnimatedScene } from '../constants/SystemAnimatedScene';
import { FixedDockResource } from '@ohos/pcsmartdock/src/main/ets/default/common/constants/FixedDockConstants';
import { SCBCompanionManager } from '@ohos/windowscene/Index';
import curves from '@ohos.curves';
import { HashMap } from '@kit.ArkTS';
import { SCBScenePanelProxy } from './SCBScenePanelProxy';
import { DividerStyle } from '../constants/DividerStyleConstants';
import { CallToState, DividerStyleConstants, SCBConstants } from '@ohos/commonconstants';
import { sceneAnimationManager } from '../instance/SceneAnimationManager';
import { pointer } from '@kit.InputKit';
import { SessionTempList, SessionTempListGroupNames } from '../utils/SessionTempListUtils';
import { PCDockUtils } from '@ohos/pcsmartdock/src/main/ets/default/utils/PCDockUtils';
import { AttractionAnimController } from '../animation/AttractionAnimController';
import { TouchGestureEvent } from '@ohos.multimodalInput.gestureEvent';
import { SplitState } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { SessionRectChangeInfo } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import { image } from '@kit.ImageKit';
import { PcModeRSSUtils } from '../utils/PcModeRSSUtils';
import { INVALID_DISPLAY_ID } from '../scenemanager/SCBPCSceneMissionProcessor';
import systemParameter from '@ohos.systemParameterEnhance';
import { LayoutPolicyHelper } from '../layout/LayoutPolicyHelper';
import { UIContextUtil } from '../utils/UIContextUtil';
import { WindowAnimationUtils } from '@ohos/windowscene/Index';
import { SCBFreeWindowsDfx } from '../utils/SCBFreeWindowsDfx';

const CLINK_NOTIFICATION_SWIPE: string = 'CLINK_NOTIFICATION_SWIPE';
const SCREEN_INDEX = 1000;
const SHOWABILITY_ISNEWWANT: string = 'const.window.showabilityisnewwant';
const COMMON_ICON_TYPE: string = 'CommonIcon';

/**
 * 基础代理类
 */
export abstract class SCBBaseFreeWindowsViewModel implements IFreeWindowsViewModel {
  protected tag = 'SCBBaseFreeWindowsViewModel';
  protected screenProperty: SCBScreenProperty;
  protected lifecyclePolicy: ILifecyclePolicy;
  protected layoutPolicy: ILayoutPolicy;
  protected animationPolicy: IAnimationPolicy;
  protected panelProxy: SCBScenePanelProxy;
  protected log: LogHelper;
  protected uiContext: UIContext;
  protected screenDpiDensity: number = -1;
  protected dockHeightInVp: number = 0;
  protected screenId: number = ViewModelConstant.INVALID_SCREEN_ID;
  protected containerSessionList: PcSCBSceneContainerSessionArray;
  protected containerSessionListNotShowRecent: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  // ----------------------------------------------------------------------------------------------------
  // 公共能力开关
  // ----------------------------------------------------------------------------------------------------
  protected needShowFullScreenAboveScreen: boolean = false;
  //是否需要互斥业务监听
  protected needMutexListener: boolean = false;
  private readonly MAX_SESSION_LIMIT_ONE_APP = 128;
  // 防止拉起窗口极限场景下，超过单个进程vsync链接数限制
  private readonly MAX_VSYNC_CONNECTION_LIMIT_ONE_APP = 200;
  private readonly APP_ICON_TRANS_ALPHA: number = 0.125;
  private readonly CARD_ICON_TRANS_ALPHA: number = 0.25;
  private readonly SCENE_TRAN_ALPHA: number = 0.75;
  private policyMap: Map<PolicyType, IBase> = new Map();
  private sceneMemoryInfoMap: Map<string, SCBSceneMemoryInfo> = new Map();
  private isNewWant: boolean = false;
  private isHide: boolean = false;
  private isAttractionEnabled: boolean = false;
  // lifecycle
  private closeSession: number | undefined = 0;
  private isCloseSplitScreen: boolean = false;
  // layout
  private pcExitSplitCommand: string = MonitorExitSplitName.DEFAULT;
  private pairPersistentId: number = -1;
  // compatibilityMode
  private windowMaxHeight: number = 0;
  private systemAppMap: Map<string, boolean> = new Map();
  // animation
  private pointerDelayTimer: number | null = null;
  private clearPointerDelayTimer: number | null = null;
  // appRecovery
  private sessionTempList: SessionTempList = new SessionTempList();
  //specificWindowNumberMap: 每个ability对应不同的flag的主窗；内层Map：每个flag对应的记忆次数，到达上限删除次数最小的flag
  private specificWindowNumberMap: Map<string, Map<string, number>> = new Map();
  private lastDensityFromDisplay: number = INVALID_DPI;
  // callback
  private startSceneFromIconCallback = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo) => {
    this.startSceneFromIcon(toInfo);
  };
  private startSceneFromRecentCallback = (persistentId?: number, containerId?: number, needRemoveSession?: boolean,
    shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void => {
    this.startSceneFromRecent(persistentId, containerId, extraInfo);
  };
  private startSceneFromOtherCallback = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void => {
    this.startSceneFromOther(toInfo);
  };
  private startSceneTransitionCallback = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void => {
    performanceMonitor.begin('LAUNCHER_APP_LAUNCH_FROM_TRANSITION',
      performanceMonitor.ActionType.LAST_UP, toInfo.bundleName);
    this.startSceneTransition(toInfo, fromInfo as SCBSceneInfo);
    performanceMonitor.end('LAUNCHER_APP_LAUNCH_FROM_TRANSITION');
  };
  private startSceneByCallCallback = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void => {
    this.startSceneByCall(toInfo, fromInfo);
  };
  private preStartSpecifiedCallback = (): void => {
    this.preStartSpecified();
  };
  private backSceneTransitionCallback = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void => {
    this.backSceneTransition(toInfo, fromInfo);
  };
  private backgroundSceneCallback = (persistentId?: number, containerId?: number): void => {
    this.backgroundScene(persistentId, containerId);
  };
  private destroySceneCallback = (persistentId?: number, containerId?: number): void => {
    this.destroyScene(persistentId, containerId);
  };
  private activateSceneCallback = (persistentId?: number, containerId?: number): void => {
    this.activateScene(persistentId, containerId);
  };
  private backgroundSceneForDelegatorCallback = (persistentId?: number, containerId?: number): void => {
    this.backgroundScene(persistentId, containerId, true);
  };
  private splitPrimaryCallback = (persistentId?: number, containerId?: number) => {
    this.onSplitPrimary(persistentId, containerId);
  };
  private splitSecondaryCallback = (persistentId?: number, containerId?: number) => {
    this.onSplitSecondary(persistentId, containerId);
  };
  private exitActiveSplitCallback = () => {
    this.onExitActiveSplit();
  };
  private minimizeSceneCallback = (persistentId?: number, containerId?: number,
    needRemoveSession?: boolean, shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo) => {
    this.onMinimizeScene(persistentId, containerId, extraInfo);
  };
  private maximizeSceneCallback = (persistentId?: number, containerId?: number) => {
    this.onMaximizeScene(persistentId, containerId);
  };
  private maximizeFullScreenSceneCallback = (persistentId?: number, containerId?: number) => {
    this.onMaximizeScene(persistentId, containerId, true);
  };
  private maximizeFloatingSceneCallback = (persistentId?: number, containerId?: number) => {
    this.onMaximizeFloatingScene(persistentId, containerId);
  };
  private closeSceneCallback = (persistentId?: number, containerId?: number, needRemoveSession?: boolean,
    isSaveSnapshot?: boolean, extraInfo?: ExecuteCallbackExtraInfo) => {
    this.onCloseScene(persistentId, containerId, isSaveSnapshot, extraInfo);
  };
  private terminateSceneCallback = (persistentId?: number, containerId?: number, needRemoveSession?: boolean,
    shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo) => {
    this.onTerminateScene(persistentId, containerId, extraInfo);
  };
  private sceneRaiseToTopCallback = (persistentId?: number, containerId?: number, needRemoveSession?: boolean,
    shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo) => {
    this.onSceneRaiseToTop(persistentId, containerId, extraInfo ? extraInfo.raiseReason : undefined);
  };
  private raiseMainWindowAboveTargetCallback = (persistentId?: number, containerId?: number,
    needRemoveSession?: boolean, shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo) => {
    this.onRaiseMainWindowAboveTarget(persistentId, extraInfo ? extraInfo.targetPersistentId : undefined);
  };
  private sceneRecoverCallback = (persistentId?: number, containerId?: number) => {
    this.onSceneRecover(persistentId, containerId);
  };
  private minimizeAllSceneCallback = () => {
    this.lifecyclePolicy.minimizeAllScene();
  };
  private sceneHiddenStartFromOtherCallback = (toInfo: SCBSceneInfo): void => {
    this.sceneHiddenStartFromOther(toInfo);
  };
  private sceneHiddenStartTransitionCallback = (toInfo: SCBSceneInfo): void => {
    this.sceneHiddenStartTransition(toInfo);
  };
  private sceneHiddenToForegroundFromOtherCallback = (toInfo: SCBSceneInfo): void => {
    this.sceneHiddenToForegroundFromOther(toInfo);
  };
  private sceneHiddenToForegroundTransitionCallback = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo,
    isBackTransition?: boolean, isFromClient?: boolean): void => {
    this.sceneHiddenToForegroundTransition(toInfo, isFromClient);
  };
  private sceneForegroundToHiddenCallback = (toInfo: SCBSceneInfo): void => {
    this.sceneForegroundToHidden(toInfo);
  };
  private sceneForegroundToHiddeTransitionCallback = (toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo,
    isBackTransition?: boolean, isFromClient?: boolean): void => {
    this.sceneForegroundToHidden(toInfo, isFromClient);
  };
  private sessionExceptionCallback = (persistentId?: number, containerId?: number, needRemoveSession?: boolean,
    shouldBackToCaller?: boolean, extraInfo?: ExecuteCallbackExtraInfo) => {
    this.onCloseSceneInner(persistentId, containerId, true, true, extraInfo);
  };
  private updateWindowDragHotAreaCallback = (persistentId: number) => {
    this.updateWindowDragHotArea(persistentId);
  };
  private switchSplitSceneCallback = (persistentId: number) => {
    this.switchSplitScene(persistentId);
  };
  private touchScreenGestureCallback: Function = (event: TouchGestureEvent) => {
  };
  private afterRemoveSessionCallback = (containerSession: SCBSceneContainerSession) => {
    this.afterRemoveSession(containerSession);
  };
  private addGestureDockRecentItem = (bundleName: string, appIndex: number): void => {
    this.panelProxy.addGestureDockRecentItem(bundleName, appIndex);
  };
  /**
   * recover one container session due to abnormal recovery
   */
  private recoverContainerSessionListCallback = (sceneSession: sceneSessionManager.SceneSession,
    sceneInfo: sceneSessionManager.SceneRecoverInfo): void => {
    this.abnormalRecoverContainerSession(sceneSession, sceneInfo);
  };
  /**
   * callback function after abnormal recovery finished
   */
  private onRecoverFinishedCallback = () => {
    this.abnormalRecoverFinished();
  };
  private addShowContainerSessionWhenLockedCallback =
    (list_: SCBSceneContainerSessionArray, isFromUnlock: boolean = false): void => {
    this.addShowWhenLockedContainerList(list_, isFromUnlock);
    };
  private removeShowContainerSessionWhenLockedCallback = (): SCBSceneContainerSessionArray => {
    return this.removeShowWhenLockedContainerList();
  };
  private initCasePosCallback = (sceneSession: SCBSceneSession) => {
    this.recoverPosBySpecifiedFlag(sceneSession);
  };
  private onContainerRequestedOrientationChange = (persistentId: number, requestedOrientation: number): void => {
    let containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (!containerSession) {
      this.log.showError('cannot find container Session with persistentId: ' + persistentId);
      return;
    }
    this.handleContainerRequestOrientation(containerSession, persistentId, requestedOrientation);
  };
  private calcWindowSizeByLimitsCallback = (scbSceneSession: SCBSceneSession, defaultWidth: number,
    defaultHeight: number): WindowSizeResult => {
    return this.calcWindowSizeByLimits(scbSceneSession, defaultWidth, defaultWidth);
  };
  private popSceneSession = (sceneInfo: SCBSceneInfo, needBackground: boolean = true,
    needRemoveSceneSession: boolean): SCBSceneSession | undefined => {
    if (sceneInfo === undefined) {
      this.log.showWarn('popSceneSession, sceneInfo is empty');
      return undefined;
    }
    let scbSceneSession: SCBSceneSession | null = null;
    if (sceneInfo.persistentId === 0) {
      scbSceneSession = this.getSceneSession(sceneInfo, true);
      if (scbSceneSession == null || sceneInfo.isNewInstance || sceneInfo.isNewAppInstance) {
        return undefined;
      }
    } else {
      scbSceneSession = this.getSceneSessionByPersistentId(sceneInfo.persistentId);
    }
    if (needRemoveSceneSession && scbSceneSession !== null) {
      const containerSession: SCBSceneContainerSession | null =
        this.getSceneContainerSessionWithPersistentId(scbSceneSession.persistentId);
      if (containerSession) {
        this.removeSceneContainerSession(containerSession);
      }
    }
    return scbSceneSession ?? undefined;
  };
  private statusViewCallback: ViewCallback = {
    onHide: (): void => this.onStatusHide()
  };
  private maximizeCompatibleSceneCallback = (persistentId?: number, containerId?: number) => {
    this.onRecoverOrMaximizeCompatibleScene(true, persistentId, containerId);
  };
  private recoverCompatibleSceneCallback = (persistentId?: number, containerId?: number) => {
    this.onRecoverOrMaximizeCompatibleScene(false, persistentId, containerId);
  };
  private onStartSceneFromPipCallback = (persistentId: number) => {
    this.onStartSceneFromPip(persistentId);
  };
  private foregroundWindowNumChangeCallback = (windowNum: number): void => {
    this.lifecyclePolicy.updateForegroundWindowNum(windowNum);
  };

  private minimizeByWindowIdsCallback = (windowIds: number[]): void => {
    let minimizeList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    windowIds.forEach((persistentId: number) => {
      const containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
      if (!containerSession) {
        this.log.showError(`cannot find containerSession with persistentId:${persistentId}`);
        return;
      }
      if (!containerSession.isActive) {
        this.log.showWarn(`containerSession is already background:${persistentId}`);
        return;
      }
      if (this.isInPanelState(ScenePanelState.RECENT)) {
        this.panelProxy.minimizeSceneInRecent(containerSession);
        return;
      }
      if (containerSession.isSplit) {
        this.exitSplitOnMinimize(persistentId);
        return;
      }
      let primarySession = containerSession.primarySession;
      if (!primarySession || primarySession.isMinimizing) {
        return;
      }
      minimizeList.push(containerSession);
    });
    this.animationPolicy.minimizeTargetWindowsAnimation(minimizeList);
  };

  constructor(uiContext: UIContext, screenProperty: SCBScreenProperty, panelProxy: SCBScenePanelProxy) {
    this.uiContext = uiContext;
    this.panelProxy = panelProxy;
    this.screenProperty = screenProperty;
    this.screenId = this.screenProperty.screenId;
    this.containerSessionList = SCBSessionListManager.getNormalContainerArray(this.screenProperty);
    this.screenDpiDensity = SCBSceneHelper.getDpi(this.screenProperty.screenId);
    this.lifecyclePolicy = new LifecyclePolicy(this);
    this.layoutPolicy = new LayoutPolicy(this);
    this.animationPolicy = new SceneAnimationPolicy(this);
    this.log = LogUtil.getInstance().createLogHelper(this.tag, this.screenProperty.screenId);
    this.dockHeightInVp = LayoutViewModel.getInstance().getDockHeight();
  }

  public onStart(): void {
    this.log.showInfo('onStart');
    UIContextUtil.getInstance().setUIContext(this.screenId, this.uiContext);
    this.onInitConfigs();
    this.registerPolicyWhenStart();
    this.policyMap.forEach((policy: IBase) => {
      policy.onStart();
    });
    if (this.needMutexListener) {
      PcModeRSSUtils.startListener();
    }
    this.registerCallback();
    this.isAttractionEnabled = AttractionAnimController.getInstance().isAttractionEnabled();
    AttractionAnimController.getInstance().registerStateChangeCallback(this.screenId,
      (isAttractionEffect: boolean): void => {
        this.isAttractionEnabled = isAttractionEffect;
        this.log.showInfo(`on attraction enable change: ${this.isAttractionEnabled}`);
      });
    this.sessionTempList.registerAfterRemoveSession(SessionTempListGroupNames.APP_RECOVER,
      this.afterRemoveSessionCallback);
    this.initScreenDpiDensity();
  }

  public onDestroy(): void {
    UIContextUtil.getInstance().delUIContext(this.screenId);
    this.sessionTempList.unRegisterAfterRemoveSession(SessionTempListGroupNames.APP_RECOVER,
      this.afterRemoveSessionCallback);
    this.unRegisterCallback();
    this.policyMap.forEach((policy: IBase) => {
      policy.onDestroy();
    });
    if (this.needMutexListener) {
      PcModeRSSUtils.stopListener();
    }
    this.policyMap.clear();
  }

  public getUiContext(): UIContext {
    return this.uiContext;
  }

  public getContainerSessionList(): PcSCBSceneContainerSessionArray {
    return this.containerSessionList;
  }

  public getContainerSessionListNotShowRecent(): SCBSceneContainerSessionArray {
    return this.containerSessionListNotShowRecent;
  }

  public getScreenProperty(): SCBScreenProperty {
    return this.screenProperty;
  }

  public getScreenDensity(): number {
    return this.screenDpiDensity;
  }

  public getPanelProxy(): SCBScenePanelProxy {
    return this.panelProxy;
  }

  public getSceneContainerSessionWithPersistentId(persistentId: number | undefined): SCBSceneContainerSession | null {
    if (persistentId === undefined) {
      this.log.showWarn('Failed to get scene containerSession because the persistentId is undefined.');
      return null;
    }
    let index = this.containerSessionList.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });
    if (index !== -1) {
      return this.containerSessionList[index];
    }

    index = this.containerSessionListNotShowRecent.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });
    if (index !== -1) {
      return this.containerSessionListNotShowRecent[index];
    }
    this.log.showWarn('Failed to get scene containerSession with session id: ' + persistentId);
    return null;
  }

  public getSceneContainerSessionWithContainerId(containerId?: number): SCBSceneContainerSession | null {
    let index = this.containerSessionList.findIndex(item => {
      return item.containerId === containerId;
    });
    if (index !== -1) {
      return this.containerSessionList[index];
    }

    index = this.containerSessionListNotShowRecent.findIndex(item => {
      return item.containerId === containerId;
    });
    if (index !== -1) {
      return this.containerSessionListNotShowRecent[index];
    }
    this.log.showWarn(`Failed to find containerSession with id:${containerId}`)
    return null;
  }

  public getPolicy<T extends IBase>(policyType: PolicyType): T | null {
    const policy = this.policyMap.get(policyType);
    if (policy === undefined) {
      return null;
    }
    return policy as T;
  }

  public exitSplitView(persistentId: number | undefined, param: ExitSplitParam = new ExitSplitParam()): void {
    this.log.showInfo('exitSplitView. persistentId: ' + persistentId);
    let index = this.containerSessionList.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });
    let currContainerSession = this.containerSessionList[index];
    if (!this.canDoExitSplitView(persistentId, index, currContainerSession)) {
      return;
    }
    AnimateToScheduleUtils.reportSplitToRss(SplitStatus.EXIT_SPLIT,
      currContainerSession.primarySession?.sceneInfo.bundleName);
    let primarySession = currContainerSession.primarySession;
    let secondarySession = currContainerSession.secondarySession;
    let raisePersistentId = persistentId;
    if (!param.needRaise) {
      raisePersistentId = primarySession?.session.persistentId === persistentId ?
        secondarySession?.session.persistentId : primarySession?.session.persistentId;
    }
    if (param.exitSplitCommand !== MonitorExitSplitName.DEFAULT) {
      this.pcExitSplitCommand = param.exitSplitCommand;
    }
    this.doExitSplitView(index, currContainerSession, false, false, true, raisePersistentId);

    if (primarySession?.session.persistentId === persistentId) {
      this.moveSessionToTargetScreen(persistentId, param.displayId, primarySession);
      this.handleProactiveExitSplit(param, primarySession, secondarySession);
      this.handlePassiveExitSplit(param, primarySession, secondarySession);
    } else {
      this.moveSessionToTargetScreen(persistentId, param.displayId, secondarySession);
      this.handlePassiveExitSplit(param, secondarySession, primarySession);
      this.handleProactiveExitSplit(param, secondarySession, primarySession);
    }
    this.containerSessionList.sortByTopmost();
    if (this.isSplitState() && param.needExitSplitRecent) {
      this.exitSplitRecentView(false);
    }
    this.panelProxy.setIsPairSplit(false)
    primarySession?.setUIFirstSwitch(sceneSessionManager.RSUIFirstSwitch.NONE);
    secondarySession?.setUIFirstSwitch(sceneSessionManager.RSUIFirstSwitch.NONE);
    this.updateStatusAfterExit(param.needExitSplitRecent);
    this.refreshZOrder();
  }

  public recoverOrMaximizeIfLastSplit(containerSession: SCBSceneContainerSession | null): void {
    if (!(containerSession && containerSession.primarySession &&
      (containerSession.primarySession.sessionData.isLastSplit ||
      containerSession.primarySession.sessionData.isNeedUpdateOnSplitRecentView))) {
      return;
    }
    if (containerSession.primarySession.sessionData.lastWindowMode === SCBSceneMode.FULLSCREEN) {
      containerSession.primarySession.maximizeFullScreen(false);
      containerSession.primarySession.currRect.copyFrom(this.calculateMaxRect(containerSession.primarySession))
      containerSession.primarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      containerSession.primarySession.floatBorderRadius = 0;
      containerSession.primarySession.shadowConfig.radius = 0;
    } else {
      containerSession.primarySession.currRect.copyFrom(containerSession.primarySession.lastRect);
      containerSession.primarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      containerSession.primarySession.setFloatCornerRadiusConfig();
      containerSession.primarySession.setWindowShadowConfig();
      containerSession.primarySession.setWindowStrokeConfig();
    }
    containerSession.primarySession.setUIFirstSwitch(sceneSessionManager.RSUIFirstSwitch.NONE);
    containerSession.primarySession.sessionData.isLastSplit = false;
    containerSession.primarySession.sessionData.isNeedUpdateOnSplitRecentView = false;
    containerSession.needTrackSplitState.setState(SplitState.UNDEFINED);
  }

  /**
   * 窗口调用hideAbility时，窗口的处理
   * @param containerSession
   * @param sceneSession
   * @param isFromClient
   */
  public doSceneHideInSceneHideMode(containerSession: SCBSceneContainerSession,
    sceneSession: SCBSceneSession, isFromClient: boolean = false): void {
    if (!containerSession || !sceneSession) {
      this.log.showError('doSceneHideInSceneHideMode containerSession or sceneSession is null');
      return;
    }
    this.removeSceneContainerSession(containerSession);
    this.addSceneContainerSessionNotShowRecent(containerSession);
    sceneSession.sessionData.isNewWant = true;
    containerSession.requestBackground();
  }

  public exitSplitViewWhenShutdown(persistentId: number | undefined): void {
    this.log.showInfo('exitSplitView. persistentId: ' + persistentId);
    const index = this.containerSessionList.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });
    let currContainerSession = this.containerSessionList[index];
    if (!this.canDoExitSplitView(persistentId, index, currContainerSession)) {
      return;
    }
    let primarySession = currContainerSession.primarySession;
    let secondarySession = currContainerSession.secondarySession;
    this.doExitSplitView(index, currContainerSession);
    primarySession?.recover();
    secondarySession?.recover();
    if (this.isSplitState()) {
      this.exitSplitRecentView();
    }
    this.updateStatusAfterExit(true);
  }

  public removeSceneContainerSession(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    this.removeSceneContainerSessionNotShowRecent(sceneContainerSession);
    const index = this.containerSessionList.findIndex((item) => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index != -1) {
      this.containerSessionList.splice(index, 1);
      this.log.showInfo(`Remove scene container session, id: ${sceneContainerSession.containerId}, ` +
        `containerSessionList.length: ${this.containerSessionList.length}`);
      this.refreshZOrder();
    } else {
      this.log.showInfo(`Not find in containerSessionList, id: ${sceneContainerSession.containerId}`);
    }
  }

  public doExitSplitView(index: number, currContainerSession: SCBSceneContainerSession,
    isNeedUpdateRecentInfo: boolean = false, isEnterPair: boolean = false, isContainerShow: boolean = true,
    raisePersistentId?: number): void {
    this.log.showDebug('currContainerSession ' + currContainerSession.containerId);
    let idxMap: Map<number, number> = new Map();
    idxMap.set(this.screenProperty.screenId, index);
    const primarySession = currContainerSession.primarySession;
    const secondarySession = currContainerSession.secondarySession;
    performanceMonitor.begin(`PC_SPLIT_EXIT_ANIMATE_${this.pcExitSplitCommand}`,
      performanceMonitor.ActionType.LAST_DOWN,
      `${primarySession?.sceneInfo.bundleName} and ${secondarySession?.sceneInfo.bundleName}`);
    if (primarySession) {
      let containerSessionForExitSplit: SCBSceneContainerSession;
      if (isContainerShow) {
        containerSessionForExitSplit = this.handleContainerSessionForExitSplit(currContainerSession,
          primarySession, idxMap, isContainerShow);
      } else {
        this.removeAllScreenSceneContainerSession(currContainerSession, idxMap);
        containerSessionForExitSplit = this.createContainerSessionForExitSplit(primarySession,
          idxMap, isContainerShow);
      }
      containerSessionForExitSplit?.needTrackSplitState.setState(SplitState.EXIT_SPLIT);
      if (isNeedUpdateRecentInfo) {
        if (this.closeSession !== primarySession.session.persistentId) {
          this.updateRecentInfoAfterExitForSplit(containerSessionForExitSplit, currContainerSession,
            primarySession, secondarySession, isEnterPair);
        }
      }
      sceneSessionManager.updateWindowMode(primarySession.session.persistentId, SCBSceneMode.FLOATING);
      if (this.isCloseSplitScreen && this.closeSession === primarySession.session.persistentId) {
        this.panelProxy.recentSceneCloseAnimate(containerSessionForExitSplit);
      }
      this.log.showInfo('Primary newSceneContainerSession, containerId: ' + containerSessionForExitSplit.containerId +
        ', bundleName: ' + primarySession.sceneInfo.bundleName +
        ', persistentId: ' + primarySession?.session.persistentId);
    }

    if (secondarySession) {
      const raiseToTop = secondarySession.sceneInfo.persistentId === raisePersistentId;
      let containerSessionForExitSplit = this.createContainerSessionForExitSplit(secondarySession,
        idxMap, isContainerShow, raiseToTop);
      containerSessionForExitSplit?.needTrackSplitState.setState(SplitState.EXIT_SPLIT);
      if (isNeedUpdateRecentInfo) {
        if (this.closeSession !== secondarySession.session.persistentId) {
          this.updateRecentInfoAfterExitForSplit(containerSessionForExitSplit, currContainerSession,
            secondarySession, primarySession, isEnterPair);
        }
      }
      if (this.isCloseSplitScreen && this.closeSession === secondarySession.session.persistentId) {
        this.panelProxy.recentSceneCloseAnimate(containerSessionForExitSplit);
      }
      sceneSessionManager.updateWindowMode(secondarySession.session.persistentId, SCBSceneMode.FLOATING);
      this.log.showInfo('Secondary newSceneContainerSession, containerId: ' + containerSessionForExitSplit.containerId +
        ', bundleName: ' + secondarySession.sceneInfo.bundleName +
        ', persistentId: ' + secondarySession?.session.persistentId);
    }
    performanceMonitor.end(`PC_SPLIT_EXIT_ANIMATE_${this.pcExitSplitCommand}`);
    this.pcExitSplitCommand = MonitorExitSplitName.DEFAULT;
  }

  public handleExitSplit(param: ExitSplitParam, primarySession: SCBSceneSession | null,
    secondarySession: SCBSceneSession | null) {
    this.handleProactiveExitSplit(param, primarySession, secondarySession);
    this.handlePassiveExitSplit(param, primarySession, secondarySession);
  }

  public destroyContainer(containerSession: SCBSceneContainerSession): void {
    containerSession.setIsClearSession(true);
    containerSession.requestDestruction(true, false, false);
    this.saveSceneMemoryInfo(containerSession);
    this.removeSceneContainerSession(containerSession);
  }

  public updateScreenProperty(screenProperty: SCBScreenProperty): void {
    this.screenProperty.copy(screenProperty);
  }

  public updateScreenDensity(screenDensity: number): void {
    this.log.showInfo(`updateScreenDensity screenDensity:${screenDensity}, lastDensity: ${this.screenDpiDensity}`);
    this.screenDpiDensity = screenDensity;
    SCBPcScenePanelManager.getInstance().updateDensity(this.screenProperty.screenId, this.screenDpiDensity);
    this.panelProxy.updateScreenDensity(screenDensity);
  }

  public closeSceneInSplitState(persistentId: number): void {
    this.closeSession = persistentId;
    this.exitSplitForPairSplit(persistentId, false);
  }

  public addSceneContainerSession(sceneContainerSession: SCBSceneContainerSession,
    needRefreshZOrder: boolean = true): void {
    if (!sceneContainerSession) {
      return;
    }
    const index = this.containerSessionList.findIndex(item => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index === -1) {
      this.containerSessionList.push(sceneContainerSession);
      this.log.showInfo(`Add scene container session, id: ${sceneContainerSession.containerId}, ` +
        `containerSessionList.length: ${this.containerSessionList.length}`);
      this.containerSessionList.sortByModalType();
      this.containerSessionList.sortByTopmost();
      if (needRefreshZOrder) {
        this.refreshZOrder();
        const primaryZOrder = sceneContainerSession.primarySession?.sessionInfo.zOrder;
        const secondaryZOrder = sceneContainerSession.secondarySession?.sessionInfo.zOrder;
        this.log.showDebug(`addSceneContainerSession primaryZorder:${primaryZOrder}, ` +
          `secondaryZorder:${secondaryZOrder}`);
      }
    }
  }

  public maximizeFromScene(persistentId: number, compatibleModeCallback: Callback<void>): void {
    const containerSession = this.getSceneContainerSessionWithPersistentIdFromAll(persistentId);
    if (containerSession === null) {
      this.log.showError('maximizeFromScene containerSession is null');
      return;
    }
    const sceneSession = this.getSceneSessionByPersistentId(persistentId);
    if (sceneSession === null) {
      this.log.showError('maximizeFromScene sceneSession is null');
      return;
    }
    this.log.showInfo('maximizeFromScene id: ' + sceneSession.session.persistentId +
      ', mode: ' + sceneSession.sceneInfo.windowMode + ', maximizeFloating: ' + sceneSession.isMaximizeFloating +
      ', rect: ' + sceneSession.currRect.printPx());
    if (sceneSession.sceneInfo.windowMode == SCBSceneMode.FLOATING && !sceneSession.isMaximizeFloating &&
      !LayoutPolicyHelper.getInstance().isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_TOP,
        sceneSession.sessionData.windowDragHotAreaTypeMap.get(this.screenProperty.screenId) ?? 0) &&
      sceneSession.sessionData.lastWindowMode !== SCBSceneMode.FULLSCREEN && !sceneSession.needMaxWithoutAnim) {
      sceneSession.saveLastRect();
    }
    // 当前dock两套未归一, 自由多窗使用AppStorage, 非自由多窗使用事件通知, 待后续dock归一后统一使用事件通知
    AppStorage.setOrCreate('isDockMissionsPopupShow', false);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_POPUP_VISIBLE_CHANGE,
      { 'isVisible': false, 'screenId': this.screenProperty.screenId });
    sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
    if (this.isInPanelState(ScenePanelState.SPLIT, ScenePanelState.RECENT) &&
      containerSession.needTrackSplitState.state !== SplitState.EXIT_SPLIT) {
      this.maximizeInRecent(sceneSession, containerSession)
      this.panelProxy.sessionRectChangeInRecent();
      return;
    }
    this.layoutPolicy.maximizeScene(sceneSession, containerSession, compatibleModeCallback);
  }

  public recoverFromScene(persistentId: number, recentCallback: Callback<void>,
    compatibleModeCallback: Callback<SCBSceneMode>): void {
    const containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (containerSession === null) {
      this.log.showError('recoverFromScene containerSession is null');
      return;
    }
    const sceneSession = this.getSceneSessionByPersistentId(persistentId);
    if (sceneSession === null) {
      this.log.showError('recoverFromScene sceneSession is null');
      return;
    }
    this.log.showInfo('recoverFromScene id: ' + sceneSession.session.persistentId + ', mode: ' +
      sceneSession.sceneInfo.windowMode + ', lastRect: ' + sceneSession.lastRect.printPx());
    if (this.isInPanelState(ScenePanelState.SPLIT, ScenePanelState.RECENT) &&
      containerSession.needTrackSplitState.state !== SplitState.EXIT_SPLIT) {
      recentCallback();
      return;
    }
    this.layoutPolicy.recoverScene(sceneSession, containerSession, compatibleModeCallback);
  }

  public splitFromScene(isSplitPrimary: boolean, persistentId: number): void {
    const containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (containerSession === null) {
      this.log.showError('splitFromScene containerSession is null');
      return;
    }
    const sceneSession = this.getSceneSessionByPersistentId(persistentId);
    if (sceneSession === null) {
      this.log.showError('splitFromScene sceneSession is null');
      return;
    }
    this.layoutPolicy.splitScene(isSplitPrimary, sceneSession, containerSession);
  }

  public initScenePosAndSize(scene: SCBSceneSession): void {
    this.initCascadePosAndSize(scene);
  }

  protected getScenePanelState(): ScenePanelState {
    return this.panelProxy.getScenePanelState();
  }

  protected registerPolicyWhenStart(): void {
    this.addPolicy(PolicyType.POLICY_LIFECYCLE, this.lifecyclePolicy);
    this.addPolicy(PolicyType.POLICY_LAYOUT, this.layoutPolicy);
    this.addPolicy(PolicyType.POLICY_ANIMATION, this.animationPolicy);
  }

  protected addPolicy<T extends IBase>(policyType: PolicyType, policy: T): void {
    this.policyMap.set(policyType, policy);
  }

  protected registerCallback(): void {
    const managerInstance: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    this.registerCallbackLifecycle(managerInstance);
    this.registerCallbackSceneOperation(managerInstance);
    this.registerCallbackHiddenStartMode(managerInstance);
    this.registerCallbackOthers(managerInstance);
    this.registerAbnormalRecoveryIfNeeded();
    this.registerViewManagerCallback();
    managerInstance.registerAddContainerSessionCallback(this.addShowContainerSessionWhenLockedCallback, this.screenId);
    managerInstance.registerRemoveContainerSessionCallback(this.removeShowContainerSessionWhenLockedCallback,
      this.screenId);
    managerInstance.registerInitCasePosCallback(this.initCasePosCallback, this.screenId);
    managerInstance.on(SCBEventId.ORIENTATION_CHANGE, this.screenId, this.onContainerRequestedOrientationChange);
    managerInstance.onShow(this.onStartSceneFromPipCallback);
    managerInstance.registerMaxForegroundWindowNumChangeCallback(this.foregroundWindowNumChangeCallback);
    managerInstance.registerMinimizeByWindowIdsCallback(this.minimizeByWindowIdsCallback);
    SCBPcScenePanelManager.getInstance().registerAddListNotShowRecentCallback(
      (containerSession: SCBSceneContainerSession) => {
        this.addSceneContainerSessionNotShowRecent(containerSession);
      }, this.screenProperty.screenId);
    SCBPcScenePanelManager.getInstance().registerRemoveListNotShowRecentCallback(
      (containerSession: SCBSceneContainerSession) => {
        this.removeSceneContainerSessionNotShowRecent(containerSession);
      }, this.screenProperty.screenId);
    SCBPcScenePanelManager.getInstance().registerSceneHiddenModeVisChangeCallback(
      (containerSession: SCBSceneContainerSession, visible?: boolean, isFromClient?: boolean) => {
        const info: SCBSceneInfo | undefined = containerSession.primarySession?.sceneInfo;
        if (info !== null && info !== undefined) {
          this.onSceneHiddenModeVisChange(info, visible, isFromClient);
        } else {
          this.log.showError('sceneInfo is invalid');
        }
      }, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().registerPopSceneSession(this.popSceneSession, this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().registerPipRestoreCallback(this.onStartSceneFromPipCallback, this.screenId);
    SCBPcScenePanelManager.getInstance().registerDisplayChangeCallback(this.onDisplayChangeCallback, this.screenId);
  }

  protected unRegisterCallback(): void {
    const managerInstance: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    this.unregisterCallbackLifecycle(managerInstance);
    this.unRegisterCallbackSceneOperation(managerInstance)
    this.unRegisterCallbackHiddenStartMode(managerInstance);
    this.unRegisterCallbackOthers(managerInstance);
    this.unregisterViewManagerCallback();
    managerInstance.unregisterAddContainerSessionCallback(this.screenId);
    managerInstance.unregisterRemoveContainerSessionCallback(this.screenId);
    managerInstance.unregisterInitCasePosCallback(this.screenId);
    managerInstance.off(SCBEventId.ORIENTATION_CHANGE, this.screenId,
      this.onContainerRequestedOrientationChange);
    managerInstance.onShow(null);
    managerInstance.unregisterSetMaxForegroundWindowNumCallback(this.foregroundWindowNumChangeCallback);
    managerInstance.unregisterMinimizeByWindowIdsCallback(this.minimizeByWindowIdsCallback);
    SCBPcScenePanelManager.getInstance().unRegisterAddListNotShowRecentCallback(this.screenId);
    SCBPcScenePanelManager.getInstance().unRegisterRemoveListNotShowRecentCallback(this.screenId);
    SCBPcScenePanelManager.getInstance().unRegisterSceneHiddenModeVisChangeCallback(this.screenId);
    SCBSceneSessionManager.getInstance().unregisterPopSceneSession(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().unregisterPipRestoreCallback(this.screenId);
    SCBPcScenePanelManager.getInstance().unregisterDisplayChangeCallback(this.screenId);
  }

  protected onInitConfigs(): void {
    this.needShowFullScreenAboveScreen = false;
    this.needMutexListener = false;
  }

  protected hideFloatingTitle(): void {
    let hideTitleSessionList: Set<SCBSceneContainerSession> = MultiInputViewModel.getInstance()
      .getHideTitleSessionList();
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      const item = this.containerSessionList[i];
      if (item !== null && item.isActive && item.primarySession !== null &&
        item.primarySession.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
        if (hideTitleSessionList && hideTitleSessionList.size > 0 && hideTitleSessionList.has(item)) {
          continue;
        }
        sceneSessionManager.updateTitleInTargetPos(item.primarySession.session.persistentId, false, 0);
        if (item.secondarySession != null) {
          sceneSessionManager.updateTitleInTargetPos(
            item.secondarySession.session.persistentId, false, 0);
        }
        break;
      }
    }
  }

  /**************************************************
   * 生命周期
   *************************************************/
  protected startSceneFromIcon(sceneInfo: SCBSceneInfo) {
    this.log.showInfo(`[SCBMain]onStartSceneFromIcon with sceneInfo:{persistentId: ${sceneInfo.persistentId}, ` +
      `bundleName: ${sceneInfo.bundleName}, moduleName: ${sceneInfo.moduleName}, ` +
      `abilityName: ${sceneInfo.abilityName}, screenId:${sceneInfo.screenId}, ` +
      `scenepanel screenId: ${this.screenProperty.screenId}`,);
    if (this.tryInterruptStartWithPadProjection(sceneInfo)) {
      return;
    }
    let sceneSession = this.requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      this.log.showError('Failed to request scene session!');
      return;
    }
    this.moveHiddenSessionToAnotherScreen(sceneSession);
    this.tryInterruptStartWithRss(sceneInfo);
    if (sceneSession.sceneInfo.screenId !== this.screenProperty.screenId) {
      sceneInfo.screenId = sceneSession.sceneInfo.screenId;
      SCBSceneSessionManager.getInstance().startSceneFromIcon(sceneInfo);
      return;
    }
    this.notifyWhenStartSceneFromIcon();
    this.log.showInfo('onStartSceneFromIcon isNewWant:' + sceneSession.isNewWant);
    SCBSceneSessionManager.getInstance().exitActiveSplit(INVALID_SCREEN_ID);
    let sceneContainerSession = this.containerSessionList.findByPersistentId(sceneSession.sceneInfo.persistentId);
    this.recoverOrMaximizeIfLastSplit(sceneContainerSession);
    if (this.isInPanelState(ScenePanelState.HOME, ScenePanelState.RECENT, ScenePanelState.APP_CENTER)) {
      this.applyStartScene(sceneInfo, sceneSession);
    } else {
      this.log.showWarn(`do nothing with scenePanel State: ${this.getScenePanelState()}`);
    }
  }

  protected startSceneFromRecent(persistentId?: number, containerId?: number, extraInfo?: ExecuteCallbackExtraInfo) {
    this.log.showInfo(`[SCBMain]onStartSceneFromRecent with persistentId:${persistentId}, ` +
      `containerId:${containerId}, screenId:${this.screenProperty.screenId}`);
    let sceneContainerSession = this.getContainerWithPersistentIdOrContainerId(persistentId, containerId);
    const visibility = sceneContainerSession?.needRenderVisibility.visibility;
    if (this.isInPanelState(ScenePanelState.SPLIT) && sceneContainerSession?.dividerParam.isSplitRecentPair) {
      this.exitSplitForPairSplit(persistentId, true);
    }
    if (!sceneContainerSession) { // recent must has container
      this.log.showError(`Failed to get sceneContainerSession with persistentId:${persistentId}!`);
      return;
    }
    if (sceneContainerSession.primarySession?.isClosing) {
      this.log.showWarn(`The sceneContainerSession: ${sceneContainerSession.containerId} is closing`);
      return;
    }
    const sceneInfo = sceneContainerSession.mainSession.sceneInfo;
    this.tryInterruptStartWithRss(sceneInfo);
    if (this.isInPanelState(ScenePanelState.SPLIT)) {
      const splitContainerSession = this.getTopActiveSplitSceneContainerSession();
      if (!splitContainerSession) {
        this.exitSplitRecentView(false);
        this.updateStatusAfterExit(true);
        return;
      }
      if (splitContainerSession.primarySession &&
        splitContainerSession.primarySession.sceneInfo.persistentId === persistentId) {
        return;
      }
      if (sceneContainerSession.primarySession?.useControlList?.[0] === ControlType.PARENT_CONTROL ||
        sceneContainerSession.primarySession?.useControlList?.[0] === ControlType.APP_LOCK) {
        this.log.showInfo('exit split scene because of the scene has been controlled.');
        this.onExitActiveSplit();
        this.raiseSceneToTop(sceneContainerSession);
        return;
      }
      this.panelProxy.getSysSceneSession().setSessionTouchable(false);
      this.dealInSplit(persistentId);
      return;
    }
    this.panelProxy.getSysSceneSession().setSessionTouchable(false);
    this.recoverOrMaximizeIfLastSplit(sceneContainerSession);
    this.resizeWhenStartSceneIfNeed(sceneContainerSession);
    const oldIsActive = sceneContainerSession.isActive;
    if (oldIsActive && sceneContainerSession.isSplit && persistentId) {
      if (persistentId === sceneContainerSession.secondarySession?.sceneInfo.persistentId) {
        SCBSceneSessionManager.getInstance().requestSceneSessionActivation(
          sceneContainerSession.secondarySession?.session, false, undefined,
          sceneContainerSession.secondarySession?.sceneInfo?.requestId);
      } else {
        SCBSceneSessionManager.getInstance().requestSceneSessionActivation(
          sceneContainerSession.primarySession?.session, false, undefined,
          sceneContainerSession.primarySession?.sceneInfo?.requestId);
      }
    } else {
      sceneContainerSession.requestActivation(false);
    }
    const requestFocusId: number | undefined = persistentId;
    this.raiseSceneToTopAsync(sceneContainerSession, requestFocusId !== undefined ? requestFocusId : 0);
    if (this.isInPanelState(ScenePanelState.RECENT)) {
      this.panelProxy.exitRecentWhenStartSceneFromRecent(sceneContainerSession);
      if (sceneContainerSession.isSplit && sceneContainerSession.secondarySession) {
        this.exitSplitIfControl(sceneContainerSession);
      }
      return;
    }
    this.enterFullSceneOrHomeViewWithSession(ScenePanelState.HOME, sceneContainerSession);

    const currContainerSession = this.getContainerWithPersistentIdOrContainerId(persistentId, containerId);
    if (oldIsActive && !sceneContainerSession.primarySession?.isMinimizing && visibility) {
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      if (this.panelProxy.isOpenFromPopup()) {
        AppStorage.set('isOpenFromPopup', false);
      }
      return;
    }

    this.startSceneFromRecentTransition(sceneContainerSession, extraInfo);
  }

  private isSceneColdStart(sceneSession: SCBSceneSession): boolean {
    let coldStart: boolean = true;
    const index = this.containerSessionList.findIndex(item => {
      return item.primarySession?.sceneInfo.persistentId === sceneSession?.sceneInfo.persistentId ||
        item.secondarySession?.sceneInfo.persistentId === sceneSession?.sceneInfo.persistentId;
    });
    if (index !== -1) {
      coldStart = false;
    }
    this.log.showInfo(`isSceneColdStart? : ${coldStart}`);
    return coldStart;
  }

  protected startSceneFromOther(sceneInfo: SCBSceneInfo) { // from console, full to free, free to full
    this.log.showInfo(`[SCBMain]onStartSceneFromOther with sceneInfo:{persistentId: ${sceneInfo.persistentId}, ` +
      `bundleName: ${sceneInfo.bundleName}, moduleName: ${sceneInfo.moduleName}, ` +
      `abilityName: ${sceneInfo.abilityName}, launchType: ${sceneInfo.launchType}, screenId: ${sceneInfo.screenId}, ` +
      `scenepanel screenId:${this.screenProperty.screenId}`);
    if (this.tryInterruptStartWithPadProjection(sceneInfo)) {
      return;
    }
    let desktopId = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_DESKTOP,
        this.screenProperty.screenId)?.id;
    if (desktopId != undefined) {
      clearTimeout(this.pointerDelayTimer);
      clearTimeout(this.clearPointerDelayTimer);
      this.pointerDelayTimer = null;
      this.clearPointerDelayTimer = null;
      pointer.setPointerStyle(desktopId, pointer.PointerStyle.DEFAULT);
    }
    let sceneSession = this.requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      this.log.showError('Failed to request scene session!');
      return;
    }
    // skip onNewWant if start scene from pip
    if (SCBSceneSessionManager.getInstance().isStartingSceneFromPiP) {
      sceneSession.sessionData.isNewWant = false;
    }
    if (this.isOldSessionAndRecentState(sceneSession)) {
      this.log.showInfo('onStartSceneFromOther alreadySessionAndRecentState');
      const container = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
      container?.requestActivation(sceneSession.isNewWant);
      container?.needRenderVisibility.setVisibilityWithDfx(true, this.tag, 'onStartSceneFromOther',
        container?.getName());
      return;
    }
    this.moveHiddenSessionToAnotherScreen(sceneSession);
    // 跨屏启动
    if (sceneSession.sceneInfo.screenId !== this.screenProperty.screenId) {
      sceneInfo.screenId = sceneSession.sceneInfo.screenId;
      SCBSceneSessionManager.getInstance().startSceneFromOther(sceneInfo);
      return;
    }
    this.log.showInfo('onStartSceneFromOther isNewWant:' + sceneSession.isNewWant);
    if (sceneSession.isActive && SCBSceneSessionManager.getInstance().getSpecialContainerSessionList()
      .getSceneSessionByPersistentId(sceneInfo.persistentId) !== null) {
      sceneSession.requestSessionActivation(sceneSession.isNewWant);
      this.log.showInfo(`The seesion is active above screenLock`);
      return;
    }
    this.tryInterruptStartWithRss(sceneInfo);
    this.notifyWhenStartSceneFromOther(sceneInfo);
    const isSameSessionInSplit: boolean = this.startSceneFromOtherCheckSplitState(sceneSession);
    if (this.isInPanelState(ScenePanelState.RECENT)) {
      this.log.showInfo('onStartSceneFromOther exit recent view.');
      this.exitRecentView();
    }
    const containerSessionRecover: SCBSceneContainerSession | undefined = this.sessionTempList.getSession(
      SessionTempListGroupNames.APP_RECOVER, sceneInfo.persistentId, true, false);
    this.log.showDebug('onStartSceneFromOther containerSessionRecover exist: ' + !!containerSessionRecover);

    let sceneContainerSession: SCBSceneContainerSession | null = containerSessionRecover ? containerSessionRecover :
      this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);

    // pc 在锁屏之上查找session
    if (SCBSceneSessionManager.getInstance().isScreenLocked() && this.startSceneFromOtherAboveKeyguardIfNeed(
      sceneSession.session.persistentId)) {
      this.log.showInfo('start scene use sceneContainerSession from special');
      return;
    }

    if (sceneContainerSession?.primarySession?.isClosing) {
      this.log.showWarn(`The sceneContainerSession: ${sceneContainerSession!.containerId} is closing`);
      return;
    }
    const coldStart: boolean = this.isSceneColdStart(sceneSession);
    if (sceneContainerSession === null) {
      sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
      this.addSceneContainerSession(sceneContainerSession);
      this.sendAndSetRecentDataList(sceneContainerSession);
      this.log.showInfo('start scene add new session: ' + sceneContainerSession.containerId);
    } else if (containerSessionRecover || this.isNeedAddToContainerListAndRemoveFromNotShowList(
      sceneSession.session.persistentId, sceneContainerSession)) {
      this.addSceneContainerSession(sceneContainerSession);
      this.sendAndSetRecentDataList(sceneContainerSession);
    }
    sceneSession.sessionData.sceneSessionEverShown = true;
    this.recoverOrMaximizeIfLastSplit(sceneContainerSession);
    this.resizeWhenStartSceneIfNeed(sceneContainerSession);
    const oldIsActive: boolean = sceneContainerSession.isActive;
    const visibility: boolean = sceneContainerSession.needRenderVisibility.visibility;
    this.isNewWant = sceneSession.isNewWant;
    this.log.showInfo(`this scene if is in activate: ${oldIsActive}, visibility: ${visibility}`);
    this.doSpecificSceneAnimateIn(sceneSession, 0);
    this.splitRequestActivation(sceneInfo);
    sceneSession.sessionData.isNewWant = true;
    if (isSameSessionInSplit === true) {
      return;
    }
    this.raiseSceneToTopAsync(sceneContainerSession, sceneSession.session.persistentId);
    if (this.isInPanelState(ScenePanelState.APP_CENTER)) {
      this.log.showInfo('onStartSceneFromOther exit appCenter view.');
      this.panelProxy.exitAppCenterView();
    }
    this.enterFullSceneOrHomeViewWithSession(ScenePanelState.HOME, sceneContainerSession);
    if (!oldIsActive || !visibility) {
      const transitionsContext = this.getTransitionsContext(sceneInfo);
      const transitionController = SCBTransitionManager.getInstance().findTransitionController(
        transitionsContext[0], () => {
        const appData = PageDesktopModel.getInstance().getCloseAppData(transitionsContext[0],
          transitionsContext[1], null, null, null, sceneInfo.appIndex, null, sceneInfo?.appInstanceKey);
        appData.screenId = this.screenProperty.screenId;
        return appData;
      });
      sceneContainerSession.initCompanionIconInfo(sceneInfo, transitionController);
      const params = sceneInfo.want?.parameters;
      if (CloseAppManager.getInstance().getStartAppSubtype() === StartSubtype.NONE) {
        CloseAppManager.getInstance().setStartAppSubtype(StartSubtype.ICON_FROM_OTHER);
      }
      performanceMonitor.begin(PageDesktopModel.getInstance().getSceneLaunchType(
        sceneContainerSession.companionIconInfo), performanceMonitor.ActionType.LAST_UP, sceneInfo.bundleName);
      if (transitionController?.appData?.startAppType === StartType.CARD || !coldStart) {
        this.log.showInfo('raiseAnimateToSchedulePriority:start app start');
        AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
        this.onSceneContainerTransitionIn(sceneContainerSession, transitionController, undefined, false, coldStart);
      } else if (sceneInfo.bundleName === CommonConstants.FILE_MANAGER_BUNDLE &&
        (!CheckEmptyUtils.isEmpty(params) || (CheckEmptyUtils.isEmpty(params) &&
        CheckEmptyUtils.isEmpty(sceneInfo.callerBundleName)))) {
        this.onSceneContainerTransitionIn(sceneContainerSession, transitionController, undefined, false, coldStart);
      } else {
        this.applyNonTraceableSceneAnimate(sceneContainerSession);
      }
    }
  }

  protected startSceneTransition(toInfo: SCBSceneInfo, fromInfo: SCBSceneInfo) { // full to full
    this.log.showInfo(`[SCBMain]onSceneStartTransition with sceneInfo:{persistentId: ${toInfo.persistentId}, ` +
      `bundleName: ${toInfo.bundleName}, moduleName: ${toInfo.moduleName}, ` +
      `abilityName: ${toInfo.abilityName}, screenId: ${toInfo.screenId}}, ` +
      `scenepanel screenId: ${this.screenProperty.screenId}`);
    if (!fromInfo) {
      this.log.showError('fromInfo is null');
      return;
    }
    this.tryInterruptStartWithRss(toInfo);
    SCBSceneSessionManager.getInstance().exitActiveSplit(INVALID_SCREEN_ID);
    let toSceneSession = this.requestSceneSession(toInfo);
    const fromSceneSession = this.getFromSceneSession(fromInfo);
    if (toSceneSession == null || fromSceneSession == null) {
      this.log.showError('Failed to get toSceneSession: ' + toInfo?.getName() + ' or fromSceneSession: ' +
      fromInfo?.getName());
      return;
    }
    this.moveHiddenSessionToAnotherScreen(toSceneSession);
    if (toSceneSession.sceneInfo.screenId !== this.screenProperty.screenId) {
      toInfo.screenId = toSceneSession.sceneInfo.screenId;
      SCBSceneSessionManager.getInstance().startSceneTransition(toInfo, fromInfo);
      return;
    }

    let specialContainerSessionList = SCBSceneSessionManager.getInstance().getSpecialContainerSessionList();
    const fromContainerSession = this.getSceneContainerSessionWithPersistentId(fromSceneSession.session.persistentId) ??
    specialContainerSessionList.findByPersistentId(fromSceneSession.session.persistentId);
    if (fromContainerSession === null && fromInfo.screenId === toInfo.screenId) {
      this.log.showError('Failed to get fromContainerSceneSession: ' + fromInfo?.getName());
      return;
    }
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
    const containerSessionRecover: SCBSceneContainerSession | undefined = this.sessionTempList.getSession(
      SessionTempListGroupNames.APP_RECOVER, toSceneSession.session.persistentId, true, false);
    this.log.showDebug('onSceneStartTransition containerSessionRecover exist: ' + !!containerSessionRecover);
    let toContainerSession = containerSessionRecover ? containerSessionRecover :
    this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);

    const fromShowAboveKeyguard = fromSceneSession.isShowAboveKeyguard;
    toContainerSession = this.exitSplitScreenAndReorder(fromShowAboveKeyguard, toContainerSession, toInfo);
    let toSpecialContainerSession = specialContainerSessionList.findByPersistentId(toSceneSession.session.persistentId);
    this.sceneSessionToSpecialSceneSession(toContainerSession, toInfo.isCalledRightlyByCallerId, fromShowAboveKeyguard);
    if (toContainerSession === null) {
      toContainerSession = fromShowAboveKeyguard ?
        toSpecialContainerSession ?? this.createSpecialContainerSession(toSceneSession, toInfo) :
      this.createContainerSession(toSceneSession);
      SCBSceneSessionManager.getInstance().requestToTop(toInfo.screenId, toInfo.persistentId);
      this.sendAndSetRecentDataList(toContainerSession);
    } else if (containerSessionRecover) {
      this.addSceneContainerSession(toContainerSession);
      this.sendAndSetRecentDataList(toContainerSession);
    }
    // skip onNewWant if start scene from pip
    if (SCBSceneSessionManager.getInstance().isStartingSceneFromPiP) {
      toSceneSession.sessionData.isNewWant = false;
    }
    toSceneSession.sessionData.sceneSessionEverShown = true;
    this.setSceneSessionOpacity(toContainerSession);
    this.recoverOrMaximizeIfLastSplit(toContainerSession);
    this.doSpecificSceneAnimateIn(toSceneSession, 0);
    this.resizeWhenStartSceneIfNeed(toContainerSession);
    const oldIsActive: boolean = toContainerSession.isActive;
    toContainerSession.requestActivation(toSceneSession.isNewWant, ActiveReason.DEFAULT, true,
      toSceneSession.sceneInfo.persistentId);
    toSceneSession.sessionData.isNewWant = true;
    if (fromShowAboveKeyguard) {
      this.raisePresentSceneToTop(toContainerSession);
      this.sendAndSetRecentDataList(toContainerSession);
    } else {
      this.raiseSceneToTop(toContainerSession);
      this.sendAndSetRecentDataList(toContainerSession);
    }
    if (this.isRecentState()) {
      this.panelProxy.refreshRecentInfo();
      this.panelProxy.recentSceneResizeAnimate();
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
      AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
      return;
    }

    if (toInfo.focusedOnShow === undefined || toInfo.focusedOnShow === true) {
      SCBSceneSessionManager.getInstance()
        .requestFocus(toSceneSession.session.persistentId, undefined, FocusChangeReason.SCB_START_APP);
    }
    this.enterFullSceneOrHomeViewWithSession(ScenePanelState.HOME, toContainerSession);
    if (toInfo.withAnimation !== undefined && toInfo.withAnimation === false) {
      this.log.showInfo('initCascadePosAndSize without animation(not support animation now)');
    }
    if (!oldIsActive) {
      this.applyNonTraceableSceneAnimate(toContainerSession);
    }
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
    AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_END);
  }

  protected backSceneTransition(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void {
    this.log.showInfo('[SCBMain]onSceneTransition toSceneInfo:' + toInfo?.getName() + ' fromInfo:' +
    fromInfo?.getName());
    if (!fromInfo) {
      this.log.showError('fromInfo is null');
      return;
    }
    const toSceneSession = this.requestSceneSession(toInfo);
    const fromSceneSession = this.getSceneSessionByPersistentId(fromInfo.persistentId);
    if (toSceneSession == null || fromSceneSession == null) {
      this.log.showError('Failed to get toSceneSession: ' + toInfo?.getName() + ' or fromSceneSession: ' +
      fromInfo?.getName());
      return;
    }
    const fromContainerSession = this.getSceneContainerSessionWithPersistentId(fromSceneSession.session.persistentId);
    const toContainerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);
    if (fromContainerSession == null || toContainerSession == null) {
      this.log.showError('Failed to get fromContainerSession: ' + toInfo?.getName() + ' or toContainerSession: ' +
      fromInfo?.getName());
      return;
    }
    toContainerSession.requestActivation(false);
    fromContainerSession.requestDestruction(true);
    this.raiseSceneToTop(toContainerSession);
    this.enterFullSceneOrHomeView(ScenePanelState.HOME)
  }

  protected backgroundScene(persistentId?: number, containerId?: number, isDelegator?: boolean) {
    this.log.showInfo(`[SCBMain]onBackgroundScene with persistentId:${persistentId} containerId:${containerId}`);
    const containerSession = this.getContainerWithPersistentIdOrContainerId(persistentId, containerId);
    if (containerSession) {
      if (isDelegator) {
        containerSession.requestBackground(isDelegator);
      } else {
        containerSession.requestBackground();
      }
    }
  }

  protected destroyScene(persistentId?: number, containerId?: number) {
    this.log.showInfo(`[SCBMain]onDestroyScene with persistentId:${persistentId} containerId:${containerId}`);
    const containerSession = this.getContainerWithPersistentIdOrContainerId(persistentId, containerId);
    if (containerSession) {
      containerSession.requestDestruction(true);
      this.removeSceneContainerSession(containerSession);
    }
    this.setRecentDataList();
  }

  protected activateScene(persistentId?: number, containerId?: number) {
    this.log.showInfo(`[SCBMain]onActivateScene with persistentId:${persistentId} containerId:${containerId}`);
    const containerSession = this.getContainerWithPersistentIdOrContainerId(persistentId, containerId);
    const curActiveContainerSession = this.containerSessionList.getTopActiveSession(); // just for full session
    if (this.needMinimizeActiveContainer(containerSession, curActiveContainerSession)) {
      curActiveContainerSession?.requestBackground();
    }
    containerSession?.requestActivation();
    if (containerSession) {
      this.raiseSceneToTop(containerSession);
    }
    this.enterFullSceneOrHomeView(ScenePanelState.HOME);
  }

  /**
   * 热启动时，将启动事件通知到其他模块，Pad特有
   */
  protected notifyWhenStartSceneFromOther(sceneInfo: SCBSceneInfo) {}

  /**
   * Icon启动时，将启动事件通知到其他模块，Pad特有
   */
  protected notifyWhenStartSceneFromIcon() {}

  protected handleContainerRequestOrientation(container: SCBSceneContainerSession, persistentId: number,
    requestedOrientation: number): void {
    if (!container.primarySession || container.primarySession?.session.persistentId !== persistentId) {
      this.log.showError('cannot find scene Session with persistentId: ' + persistentId);
      return;
    }
  }

  /**
   * back手势与应用关闭差异化，Pad特有
   */
  protected shouldInterruptTerminateForBackGesture(container: SCBSceneContainerSession, reason?: string): boolean {
    return false;
  }

  protected calcIsClearSession(extraInfo?: ExecuteCallbackExtraInfo): boolean {
    const isClearSession = extraInfo?.terminatedByAbility ? false : true;
    return isClearSession;
  }

  /**
   * 部分热启动场景下需要重新计算窗口尺寸，Pad特有
   */
  protected resizeWhenStartSceneIfNeed(container: SCBSceneContainerSession): void {
  }

  /*
   * 组成分屏时，在切换成自由多窗前打开的窗口需要计算自由窗大小
   */
  protected resizeWhenPairSplitIfNeed(container: SCBSceneContainerSession): void {
  }

  /**
   * RSS重载业务处理，部分场景会有特殊处理,Pad自由多窗特有,默认不执行
   */
  protected tryInterruptStartWithRss(sceneInfo: SCBSceneInfo): void{
    return;
  }

  protected canDoAttractionAnim(): boolean {
    return this.isAttractionEnabled;
  }

  /**
   * 自由多窗模式下PAD投屏车机之后需要拦截投屏应用的启动
   */
  protected tryInterruptStartWithPadProjection(sceneInfo: SCBSceneInfo): boolean {
    return false;
  }

  protected fixAttractionTranslate(): number {
    return 0;
  }

  protected getIconRect(appItem: AppItemInfo): RectInfo {
    this.log.showError(`getIconRect is not implemented, default implement may cause error`);
    let rectInfo: RectInfo = new RectInfo();
    return rectInfo;
  }

  protected isHideOnDock(appItem: AppItemInfo): boolean {
    this.log.showError(`isHideOnDock is not implied, default implement may cause error`);
    return false;
  }

  protected sendAndSetRecentDataList(sceneContainerSession: SCBSceneContainerSession,
    isNeedHideAppCenter: boolean = true): void {
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_CONTAINER_SESSION_ADDED, sceneContainerSession);
    this.setRecentDataList(isNeedHideAppCenter);
  }

  protected setRecentDataList(isNeedHideAppCenter: boolean = true): void {
    this.panelProxy.setRecentDataList(isNeedHideAppCenter);
  }

  protected initSceneWhenCreateSceneSession(scene: SCBSceneSession, session: sceneSessionManager.SceneSession): void {
    if (sSCBOobeManager.isEnable()) {
      sceneSessionManager.updateWindowMode(scene.sceneInfo.persistentId, SCBSceneMode.FULLSCREEN);
    } else {
      scene.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    }
    if (scene.sceneInfo.fullScreenStart) {
      this.initFullScreenWindow(scene);
    } else {
      scene.sceneInfo.configWindowTop = session.windowTop;
      scene.sceneInfo.configWindowLeft = session.windowLeft;
      scene.sceneInfo.configWindowWidth = session.windowWidth;
      scene.sceneInfo.configWindowHeight = session.windowHeight;
      scene.sceneInfo.isMaximize = session.isMaximize;
      this.initCascadePosAndSize(scene);
    }
  }

  protected initCascadePosAndSize(scbSceneSession: SCBSceneSession, specifiedRect?: sceneSessionManager.SessionRect) {
    let statusBarHeight: number =
      SCBSystemSceneUtils.getInstance().getStatusBarHeightVP(this.uiContext, this.screenProperty.screenId);
    let screenWidthInVp = px2vp(this.screenProperty.width);
    let screenHeightInVp = px2vp(this.screenProperty.height);
    let screenLimitWidthInVp = px2vp(this.screenProperty.width);
    let screenLimitHeightInVp = px2vp(this.screenProperty.height) - statusBarHeight - this.dockHeightInVp;
    let info = scbSceneSession.sceneInfo;

    //限制的大小宽度
    const limitRect: ViewArea = {
      left: 0,
      top: statusBarHeight,
      width: screenLimitWidthInVp,
      height: screenLimitHeightInVp
    }
    if (this.supportedOnlyFullScreen(scbSceneSession)) {
      return;
    }

    let isWhitelistApp: boolean = this.isWhitelistApp(scbSceneSession);
    let key: string = SCBPcScenePanelManager.getInstance().createIsWindowRectAutoSaveKey(info);

    if (!isWhitelistApp && !specifiedRect && !info.windowTop && !info.windowLeft && !info.windowWidth &&
      !info.windowHeight) {
      if (this.recoverPosIfNeeded(scbSceneSession)) {
        scbSceneSession.isRecoveredScene = true;
        this.log.showInfo(`init cascade pos and size with the scene memory info, ` +
          `width: ${scbSceneSession.currRect.width.getPx()}, height: ${scbSceneSession.currRect.height.getPx()}, ` +
          `translateX: ${scbSceneSession.currRect.left.getPx()}, translateY: ${scbSceneSession.currRect.top.getPx()},` +
          ` screenWidthInVp: ${screenWidthInVp}, screenHeightInVp: ${screenHeightInVp}, ` +
          `statusBarHeight: ${statusBarHeight}`);
        return;
      }
      if (SCBPcScenePanelManager.getInstance().getIsWindowRectAutoSaveMap(key)) {
        let persistentId: number = scbSceneSession.session.persistentId;
        if (this.checkMultiInstances(key, persistentId) && this.setSizeAndPositionForMultiInstances(scbSceneSession)) {
          return;
        }
      }
      if (this.initWindowMaximize(scbSceneSession)) {
        return;
      }
      this.setDefaultSizeAndPosition(scbSceneSession);
    }

    let windowLeft: number = specifiedRect?.posX_ ?? scbSceneSession.sceneInfo.windowLeft;
    let windowTop: number = specifiedRect?.posY_ ?? scbSceneSession.sceneInfo.windowTop;
    const windowHeight: number = specifiedRect?.height_ ?? scbSceneSession.sceneInfo.windowHeight;
    const windowWidth: number = specifiedRect?.width_ ?? scbSceneSession.sceneInfo.windowWidth;
    let windowSize: WindowSizeResult = this.getDefaultWindowSize(scbSceneSession, screenWidthInVp, screenHeightInVp,
      windowWidth, windowHeight);
    const dpiRatio = this.screenDpiDensity / ViewModelConstant.BASE_DENSITY;
    let defaultWidth = this.scbVp2RealVpWithDpiRatio(windowSize.width, dpiRatio);
    let defaultHeight = this.scbVp2RealVpWithDpiRatio(windowSize.height, dpiRatio);
    const ret = this.calcWindowSizeByLimits(scbSceneSession, defaultWidth, defaultHeight);
    defaultWidth = this.realVp2ScbVpWithDpiRatio(ret.width, dpiRatio);
    defaultHeight = this.realVp2ScbVpWithDpiRatio(ret.height, dpiRatio);
    let translateX = limitRect.left + (limitRect.width - defaultWidth) * HALF;
    let translateY = limitRect.top + (limitRect.height - defaultHeight) * HALF;
    const initPosRet = this.getInitPos(defaultWidth, defaultHeight, translateX, translateY, key);
    translateX = initPosRet.translateX;
    translateY = initPosRet.translateY;
    let titleHeight = StyleConstants.DEFAULT_CONTAINER_TITLE_HEIGHT;
    const posCollision = this.positionalCollision(windowLeft, windowTop, defaultWidth, defaultHeight, titleHeight);
    translateX = posCollision.translateX !== INVALID_POSITION ? posCollision.translateX : translateX;
    translateY = posCollision.translateY !== INVALID_POSITION ? posCollision.translateY : translateY;
    scbSceneSession.currRect.setSizeNum(vp2px(defaultWidth), vp2px(defaultHeight));
    scbSceneSession.currRect.setPosNum(vp2px(translateX), vp2px(translateY));
    this.log.showInfo(`init cascade pos and size, width: ${scbSceneSession.currRect.width.getPx()}, height: ` +
      `${scbSceneSession.currRect.height.getPx()}, translateX: ${scbSceneSession.currRect.left.getPx()}, translateY: ` +
      `${scbSceneSession.currRect.top.getPx()}, screenWidthInVp: ${screenWidthInVp}, screenHeightInVp: ` +
      `${screenHeightInVp}, statusBarHeight: ${statusBarHeight}, screenLimitWidthInVp: ` +
      `${screenLimitWidthInVp}, screenLimitHeightInVp: ${screenLimitHeightInVp}`);
  }

  protected isInPanelState(...stateArray: ScenePanelState[]) {
    const panelState = this.panelProxy.getScenePanelState();
    for (let item of stateArray) {
      if (item === panelState) {
        return true;
      }
    }
    return false;
  }

  protected getMaximizeRect(top: number): SCBSessionRect {
    let screenInfo = this.getRealScreenInfo(top);
    return new SCBSessionRect(0, screenInfo.maxTop, screenInfo.screenWidth, screenInfo.screenHeightLimit);
  }

  protected initFullScreenWindow(scbSceneSession: SCBSceneSession, specifiedRect?: sceneSessionManager.SessionRect) {
    let floatingWindowRect: SCBSessionRect = this.calcFloatingWindowSize(scbSceneSession, specifiedRect);
    this.log.showInfo(`initFullScreenWindow lastRect:${scbSceneSession.lastRect.printPx()},` +
      `floatingWindowRect:${floatingWindowRect.printPx()}`);
    scbSceneSession.lastRect.setRect(floatingWindowRect.left, floatingWindowRect.top,
      floatingWindowRect.width, floatingWindowRect.height);
    scbSceneSession.currRect.setSizeNum(this.screenProperty.width, this.getFullScreenWindowHeight(scbSceneSession));
    scbSceneSession.currRect.setPosNum(0, 0);
    scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
  }

  protected getRealScreenInfo(windowTop: number): RealScreenInfo {
    let screenId = this.screenId;
    let statusBarHeightPx = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenId);
    let dockHeight = 0;
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    let dockRect = new SCBSessionRect(0, 0, 0, 0);
    if (dock) {
      dockRect.copyFrom(dock.currRect);
      dockHeight = dock.currRect.height.getPx();
    } else {
      this.log.showError('getRealScreenInfo SmartDock no exit');
    }
    let screenWidth = this.screenProperty.width;
    let screenHeight = this.screenProperty.height;
    let screenHeightLimit = screenHeight - statusBarHeightPx - dockHeight;
    let maxTop = statusBarHeightPx;
    let maxBottom = screenHeight - dockHeight;
    let fullScreenTop = 0;
    return new RealScreenInfo(screenWidth, screenHeight, screenHeightLimit, maxTop, maxBottom, fullScreenTop);
  }

  protected getDefaultWindowSize(scbSceneSession: SCBSceneSession, screenWidthInVp: number,
    screenHeightInVp: number, windowWidth: number, windowHeight: number): WindowSizeResult {
    let result: WindowSizeResult = new WindowSizeResult();
    if (!scbSceneSession) {
      return result;
    }
    let defaultWidth: number = screenWidthInVp * DEFAULT_RATIO;
    if (windowWidth !== undefined) {
      defaultWidth = px2vp(windowWidth);
    }
    result.width = defaultWidth;

    let defaultHeight: number = screenHeightInVp * DEFAULT_RATIO;
    if (windowHeight !== undefined) {
      defaultHeight = px2vp(windowHeight);
    }
    result.height = defaultHeight;
    return result;
  }

  protected refreshZOrder(): void {
    SCBSessionListManager.refreshZOrder();
  }

  protected refreshWindowRectAutoSave(scene: SCBSceneSession): void {
    this.setSystemOrSupportAppIsEnableSpecified(scene);
    this.setSystemOrSupportAppWindowRectAutoSave(scene);
    this.setIsWindowRectAutoSave(scene);
  }

  protected recoverMaximizeScene(scbSceneSession: SCBSceneSession, sceneMemoryInfo: SCBSceneMemoryInfo,
    screenInfo: RealScreenInfo): void {
    let lastRect = sceneMemoryInfo.lastRect.copy();
    let statusBarHeightPx = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenId);
    let width: number = lastRect.width.getPx();
    let height: number = lastRect.height.getPx();
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, this.screenProperty.screenId);
    let dockHeight = dock ? dock.currRect.height.getPx() : 0;
    if (Math.abs(width) < MINI_VALUE && Math.abs(height) < MINI_VALUE) {
      let defaultWidth: number = screenInfo.screenWidth * DEFAULT_RATIO;
      let defaultHeight: number = screenInfo.screenHeightLimit * DEFAULT_RATIO;
      let defaultTop: number = (screenInfo.screenHeightLimit - statusBarHeightPx -
      this.dockHeightInVp - defaultHeight) / 2;
      let defaultLeft: number = (screenInfo.screenWidth - defaultWidth) / 2;
      lastRect.setPosNum(defaultLeft, defaultTop);
      lastRect.setSizeNum(defaultWidth, defaultHeight);
    }
    let isDockAutoHide = AppStorage.get<boolean>('isDockAutoHide');
    if (sceneMemoryInfo.layoutFullScreen) {
      let curDpi: number = this.screenDpiDensity;
      if (sceneMemoryInfo.lastDpi > 0 && curDpi !== sceneMemoryInfo.lastDpi) {
        let dpiRatio = curDpi / sceneMemoryInfo.lastDpi;
        lastRect = this.calcRectAfterDpiChange(lastRect, dpiRatio);
      }
      lastRect = this.UpdateOutScreenRect(lastRect, screenInfo);
      scbSceneSession.currRect.setRect(lastRect.left, lastRect.top, lastRect.width, lastRect.height);
    } else {
      scbSceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
      let currRect = this.getMaximizeRect(sceneMemoryInfo.currRect.top.getPx());
      let sceneHeight = screenInfo.screenHeightLimit;
      let sceneTop = currRect.top.getPx();
      if (scbSceneSession.layoutFullScreen) {
        let screenWidth = this.screenProperty.width;
        let screenHeight = this.screenProperty.height;
        currRect = new SCBSessionRect(0, 0, screenWidth, screenHeight);
      } else if (isDockAutoHide) {
        if (this.screenProperty.screenId !== SCBSceneSessionManager.getInstance().mainScreenId) {
          sceneHeight = sceneHeight + dockHeight;
          sceneTop = 0;
        } else {
          sceneHeight = sceneHeight + statusBarHeightPx + dockHeight;
          sceneTop = 0;
        }
        currRect = new SCBSessionRect(0, sceneTop, screenInfo.screenWidth, sceneHeight);
      }
      scbSceneSession.currRect.copyFrom(currRect);
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      SCBSceneHelper.updateLastDpi(scbSceneSession,
        sceneMemoryInfo.lastDpi > 0 ? sceneMemoryInfo.lastDpi : this.screenDpiDensity);
      scbSceneSession.isRecoveredFullScreen = true;
      lastRect = this.UpdateOutScreenRect(lastRect, screenInfo);
      scbSceneSession.lastRect.setRect(lastRect.left, lastRect.top, lastRect.width, lastRect.height);
    }
    if (scbSceneSession.isRecoveredFullScreen) {
      SCBSceneHelper.updateSceneSafeRect(scbSceneSession);
      scbSceneSession.floatBorderRadius = 0;
    }
  }

  protected maximizeInRecent(sceneSession: SCBSceneSession, containerSession: SCBSceneContainerSession):void {
    const sessionRect = LayoutPolicyHelper.getInstance().calculateMaxRect(sceneSession, this.screenProperty);
    sceneSession.currRect.copyFrom(sessionRect);
    sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    sceneSession.sessionData.isMaximizeFloating = false;
    containerSession.getNeedRenderDragHotAreaAnimConfig(this.screenProperty.screenId).isWindowDragHotArea = false;
  }

  private addShowWhenLockedContainerList(containerList: SCBSceneContainerSessionArray, isFromUnlock: boolean) {
    for (let item of containerList) {
      this.log.showInfo('Add scene container session, id: ' + item.containerId);
      item.primarySession?.setShowAboveKeyguard(false);
      if (this.needShowFullScreenAboveScreen && isFromUnlock) {
        if (item?.isActive) {
          this.resizeWhenStartSceneIfNeed(item);
        }
      }
      this.addSceneContainerSession(item, false);
      this.sendAndSetRecentDataList(item);
    }
    if (containerList.length > 0) {
      this.refreshZOrder();
    }
  }

  private registerCallbackLifecycle(managerInstance: SCBSceneSessionManager): void {
    managerInstance.on(SCBEventId.START_SCENE_FROM_ICON, this.screenId, this.startSceneFromIconCallback);
    managerInstance.on(SCBEventId.START_SCENE_FROM_RECENT, this.screenId, this.startSceneFromRecentCallback);
    managerInstance.on(SCBEventId.START_SCENE_FROM_OTHER, this.screenId, this.startSceneFromOtherCallback);
    managerInstance.on(SCBEventId.START_SCENE_TRANSITION, this.screenId, this.startSceneTransitionCallback);
    managerInstance.on(SCBEventId.START_SCENE_BYCALL, this.screenId, this.startSceneByCallCallback);
    managerInstance.on(SCBEventId.PRE_START_SPECIFIED, this.screenId, this.preStartSpecifiedCallback);
    managerInstance.on(SCBEventId.BACK_SCENE_TRANSITION, this.screenId, this.backSceneTransitionCallback);
    managerInstance.on(SCBEventId.BACKGROUND_SCENE, this.screenId, this.backgroundSceneCallback);
    managerInstance.on(SCBEventId.DESTROY_SCENE, this.screenId, this.destroySceneCallback);
    managerInstance.on(SCBEventId.ACTIVATE_SCENE, this.screenId, this.activateSceneCallback);
    managerInstance.on(SCBEventId.BACKGROUND_SCENE_FOR_DELEGATOR, this.screenId,
      this.backgroundSceneForDelegatorCallback);
  }

  private unregisterCallbackLifecycle(managerInstance: SCBSceneSessionManager): void {
    managerInstance.off(SCBEventId.START_SCENE_FROM_ICON, this.screenId, this.startSceneFromIconCallback);
    managerInstance.off(SCBEventId.START_SCENE_FROM_RECENT, this.screenId, this.startSceneFromRecentCallback);
    managerInstance.off(SCBEventId.START_SCENE_FROM_OTHER, this.screenId, this.startSceneFromOtherCallback);
    managerInstance.off(SCBEventId.START_SCENE_TRANSITION, this.screenId, this.startSceneTransitionCallback);
    managerInstance.off(SCBEventId.START_SCENE_BYCALL, this.screenId, this.startSceneByCallCallback);
    managerInstance.off(SCBEventId.PRE_START_SPECIFIED, this.screenId, this.preStartSpecifiedCallback);
    managerInstance.off(SCBEventId.BACK_SCENE_TRANSITION, this.screenId, this.backSceneTransitionCallback);
    managerInstance.off(SCBEventId.BACKGROUND_SCENE, this.screenId, this.backgroundSceneCallback);
    managerInstance.off(SCBEventId.DESTROY_SCENE, this.screenId, this.destroySceneCallback);
    managerInstance.off(SCBEventId.ACTIVATE_SCENE, this.screenId, this.activateSceneCallback);
    managerInstance.off(SCBEventId.BACKGROUND_SCENE_FOR_DELEGATOR, this.screenId,
      this.backgroundSceneForDelegatorCallback);
  }

  private registerCallbackSceneOperation(managerInstance: SCBSceneSessionManager): void {
    this.registerCallbackSplit(managerInstance);
    managerInstance.on(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId, this.minimizeSceneCallback);
    managerInstance.on(SCBEventId.MAXIMIZE_SCENE, this.screenProperty.screenId, this.maximizeSceneCallback);
    managerInstance.on(SCBEventId.MAXIMIZE_FULLSCREEN_SCENE, this.screenProperty.screenId,
      this.maximizeFullScreenSceneCallback);
    managerInstance.on(SCBEventId.MAXIMIZE_FLOATING_SCENE, this.screenProperty.screenId,
      this.maximizeFloatingSceneCallback);
    managerInstance.on(SCBEventId.CLOSE_SCENE, this.screenProperty.screenId, this.closeSceneCallback);
    managerInstance.on(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId, this.terminateSceneCallback);
    managerInstance.on(SCBEventId.SESSION_RAISE_TO_TOP, this.screenProperty.screenId, this.sceneRaiseToTopCallback);
    managerInstance.on(SCBEventId.RAISE_MAIN_WINDOW_ABOVE_TARGET, this.screenProperty.screenId,
      this.raiseMainWindowAboveTargetCallback);
    managerInstance.on(SCBEventId.SESSION_RECOVER, this.screenProperty.screenId, this.sceneRecoverCallback);
    managerInstance.on(SCBEventId.MINIMIZE_ALL_SCENE, this.screenProperty.screenId, this.minimizeAllSceneCallback);
  }

  private unRegisterCallbackSceneOperation(managerInstance: SCBSceneSessionManager): void {
    this.unRegisterCallbackSplit(managerInstance);
    managerInstance.off(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId, this.minimizeSceneCallback);
    managerInstance.off(SCBEventId.MAXIMIZE_SCENE, this.screenProperty.screenId, this.maximizeSceneCallback);
    managerInstance.off(SCBEventId.MAXIMIZE_FULLSCREEN_SCENE, this.screenProperty.screenId,
      this.maximizeFullScreenSceneCallback);
    managerInstance.off(SCBEventId.MAXIMIZE_FLOATING_SCENE, this.screenProperty.screenId,
      this.maximizeFloatingSceneCallback);
    managerInstance.off(SCBEventId.CLOSE_SCENE, this.screenProperty.screenId, this.closeSceneCallback);
    managerInstance.off(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId, this.terminateSceneCallback);
    managerInstance.off(SCBEventId.SESSION_RAISE_TO_TOP, this.screenProperty.screenId, this.sceneRaiseToTopCallback);
    managerInstance.off(SCBEventId.RAISE_MAIN_WINDOW_ABOVE_TARGET, this.screenProperty.screenId,
      this.raiseMainWindowAboveTargetCallback);
    managerInstance.off(SCBEventId.SESSION_RECOVER, this.screenProperty.screenId, this.sceneRecoverCallback);
    managerInstance.off(SCBEventId.MINIMIZE_ALL_SCENE, this.screenProperty.screenId, this.minimizeAllSceneCallback);
  }

  private registerCallbackSplit(managerInstance: SCBSceneSessionManager): void {
    managerInstance.on(SCBEventId.SPLIT_PRIMARY, this.screenId, this.splitPrimaryCallback);
    managerInstance.on(SCBEventId.SPLIT_SECONDARY, this.screenId, this.splitSecondaryCallback);
    managerInstance.on(SCBEventId.EXIT_ACTIVE_SPLIT, this.screenId, this.exitActiveSplitCallback);
  }

  private unRegisterCallbackSplit(managerInstance: SCBSceneSessionManager): void {
    managerInstance.off(SCBEventId.SPLIT_PRIMARY, this.screenId, this.splitPrimaryCallback);
    managerInstance.off(SCBEventId.SPLIT_SECONDARY, this.screenId, this.splitSecondaryCallback);
    managerInstance.off(SCBEventId.EXIT_ACTIVE_SPLIT, this.screenId, this.exitActiveSplitCallback);
  }

  private registerCallbackHiddenStartMode(managerInstance: SCBSceneSessionManager): void {
    managerInstance.on(SCBEventId.HIDDEN_START_SCENE_FROM_OTHER, this.screenProperty.screenId,
      this.sceneHiddenStartFromOtherCallback);
    managerInstance.on(SCBEventId.HIDDEN_START_SCENE_TRANSITION, this.screenProperty.screenId,
      this.sceneHiddenStartTransitionCallback);
    managerInstance.on(SCBEventId.HIDDEN_TO_FOREGROUND_FROM_OTHER, this.screenProperty.screenId,
      this.sceneHiddenToForegroundFromOtherCallback);
    managerInstance.on(SCBEventId.HIDDEN_TO_FOREGROUND_TRANSITION, this.screenProperty.screenId,
      this.sceneHiddenToForegroundTransitionCallback);
    managerInstance.on(SCBEventId.FOREGROUND_TO_HIDDEN_FROM_OTHER, this.screenProperty.screenId,
      this.sceneForegroundToHiddenCallback);
    managerInstance.on(SCBEventId.FOREGROUND_TO_HIDDEN_TRANSITION, this.screenProperty.screenId,
      this.sceneForegroundToHiddeTransitionCallback);
  }

  private unRegisterCallbackHiddenStartMode(managerInstance: SCBSceneSessionManager): void {
    managerInstance.off(SCBEventId.HIDDEN_START_SCENE_FROM_OTHER, this.screenProperty.screenId,
      this.sceneHiddenStartFromOtherCallback);
    managerInstance.off(SCBEventId.HIDDEN_START_SCENE_TRANSITION, this.screenProperty.screenId,
      this.sceneHiddenStartTransitionCallback);
    managerInstance.off(SCBEventId.HIDDEN_TO_FOREGROUND_FROM_OTHER, this.screenProperty.screenId,
      this.sceneHiddenToForegroundFromOtherCallback);
    managerInstance.off(SCBEventId.HIDDEN_TO_FOREGROUND_TRANSITION, this.screenProperty.screenId,
      this.sceneHiddenToForegroundTransitionCallback);
    managerInstance.off(SCBEventId.FOREGROUND_TO_HIDDEN_FROM_OTHER, this.screenProperty.screenId,
      this.sceneForegroundToHiddenCallback);
    managerInstance.off(SCBEventId.FOREGROUND_TO_HIDDEN_TRANSITION, this.screenProperty.screenId,
      this.sceneForegroundToHiddeTransitionCallback);
  }

  private registerCallbackOthers(managerInstance: SCBSceneSessionManager): void {
    managerInstance.on(SCBEventId.SESSION_EXCEPTION, this.screenId, this.sessionExceptionCallback);
    managerInstance.on(SCBEventId.UPDATE_WINDOW_DRAG_HOT_AREA, this.screenId,
      this.updateWindowDragHotAreaCallback);
    managerInstance.on(SCBEventId.SWITCH_SPLIT_SCENE, this.screenId, this.switchSplitSceneCallback);
    managerInstance.registerAddGestureDockRecentItemCallback(this.addGestureDockRecentItem);
  }

  private unRegisterCallbackOthers(managerInstance: SCBSceneSessionManager): void {
    managerInstance.off(SCBEventId.SESSION_EXCEPTION, this.screenId, this.sessionExceptionCallback);
    managerInstance.off(SCBEventId.UPDATE_WINDOW_DRAG_HOT_AREA, this.screenId,
      this.updateWindowDragHotAreaCallback);
    managerInstance.off(SCBEventId.SWITCH_SPLIT_SCENE, this.screenId, this.switchSplitSceneCallback);
    managerInstance.unregisterAddGestureDockRecentItemCallback();
  }

  private registerAbnormalRecoveryIfNeeded() {
    this.log.showInfo(`IsAbnormalRecovery = ${SCBRecoverManager.getInstance().isAbnormalRecovery()}`)
    if (SCBRecoverManager.getInstance().isAbnormalRecovery()) {
      SCBSceneSessionManager.getInstance().registerRecoverSessionCallback(this.recoverContainerSessionListCallback,
        this.screenProperty.screenId);
      SCBRecoverManager.getInstance().setOnRecoverFinishedCallback(this.onRecoverFinishedCallback);
    } else {
      SCBSceneSessionManager.getInstance().getScenePersistent().deletePersistData();
    }
  }

  private registerViewManagerCallback(): void {
    this.log.showInfo('registerViewManagerCallback');
    viewMgrPolicy.registerViewCallback(ViewType.STATUS_BAR, this.statusViewCallback);
  }

  private unregisterViewManagerCallback(): void {
    viewMgrPolicy.unRegisterViewCallback(ViewType.STATUS_BAR, this.statusViewCallback);
  }

  private onStatusHide(): void {
    let sceneSessionMgr = SCBSceneSessionManager.getInstance();
    if (sceneSessionMgr.getIsStatusBarShownForHover()) {
      this.log.showInfo('hide floating title when status bar has been hidden');
      this.hideFloatingTitle();
    }
    let container = sceneSessionMgr.getSessionOfTopFullScreenSubSession(this.screenProperty.screenId);
    let subSession = sceneSessionMgr.getTopFullScreenSubSession(this.screenProperty.screenId, container);
    if (subSession && sceneSessionMgr.getIsStatusBarShownForHover()) {
      this.log.showInfo('hide subSession title when status bar has been hidden');
      sceneSessionManager.updateTitleInTargetPos(subSession.session.persistentId, false, 0);
    }
  }

  private startSceneFromOtherAboveKeyguardIfNeed(persistentId: number | undefined): boolean {
    if (persistentId === undefined) {
      this.log.showWarn('Failed to get scene containerSession from special because the persistentId is undefined.');
      return false;
    }

    let sceneContainerSession: SCBSceneContainerSession | null =
      this.getSceneContainerSessionWithPersistentIdFromSpecial(persistentId);
    if (!sceneContainerSession || !sceneContainerSession.primarySession) {
      this.log.showWarn('Failed to get sceneContainerSession from special.');
      return false;
    }
    SCBSceneSessionManager.getInstance()
      .startSceneFromOtherAboveKeyguard(sceneContainerSession.primarySession.sceneInfo);
    return true;
  }

  private getSceneContainerSessionWithPersistentIdFromSpecial(
    persistentId: number | undefined): SCBSceneContainerSession | null {
    if (persistentId === undefined) {
      this.log.showWarn('Failed to get scene containerSession from special because the persistentId is undefined.');
      return null;
    }
    return SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().findByPersistentId(persistentId);
  }

  private getSceneContainerSessionWithPersistentIdFromAll(persistentId: number): SCBSceneContainerSession | null {
    const containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (containerSession) {
      return containerSession;
    }
    const specialContainerSession = this.getSceneContainerSessionWithPersistentIdFromSpecial(persistentId);
    if (specialContainerSession) {
      return specialContainerSession;
    }
    return null;
  }

  /**
   * 判断当前sceneSession会话是否是已有会话，并判断当前SCBScenePanel是否为任务中心状态
   * @param sceneSession
   * @returns
   */
  private isOldSessionAndRecentState(sceneSession: SCBSceneSession): boolean {
    if (!sceneSession) {
      return false;
    }
    return this.isInPanelState(ScenePanelState.RECENT) && sceneSession.isNewWant &&
      this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId) !== null;
  }

  private preStartSpecified(): void {
    this.log.showInfo('[SCBMain]preStartSpecified start.');
    this.setPointerDelayTimer();
    this.setClearPointerDelayTimer();
  }

  private afterRemoveSession(containerSession: SCBSceneContainerSession): void {
    this.log.showInfo('afterRemoveSession');
    containerSession.setIsClearSession(true);
    containerSession.requestDestruction(true);
  }

  private startSceneByCall(toInfo: SCBSceneInfo, fromInfo?: SCBSceneInfo): void {
    this.log.showInfo('[SCBMain]onSceneStartByCall with toInfo:' + toInfo?.getName() + ' fromInfo:' +
    fromInfo?.getName());
    if (!fromInfo) {
      this.log.showError('onSceneStartByCall fromInfo is null');
      return this.startSceneByCallFromRoot(toInfo);
    }
    const topActiveSceneSession = this.containerSessionList.getTopActiveSession();
    let toSceneSession = this.requestSceneSession(toInfo);
    const fromSceneSession = this.getSceneSessionByPersistentId(fromInfo.persistentId);
    if (toSceneSession == null || fromSceneSession == null) {
      this.log.showError('[SCBMain]Failed to get toSceneSession: ' + toInfo?.getName() + ' or fromSceneSession: ' +
      fromInfo?.getName());
      return;
    }
    const fromContainerSession = this.getSceneContainerSessionWithPersistentId(fromSceneSession.session.persistentId);
    let toContainerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);
    if (fromContainerSession == null) {
      this.log.showError('Failed to get fromContainerSceneSession: ' + fromInfo?.getName());
      return;
    }
    let isFirstCall = false;
    if (toContainerSession === null) {
      toContainerSession = new SCBSceneContainerSession(toSceneSession, this.screenProperty);
      isFirstCall = true;
    }
    this.resizeWhenStartSceneIfNeed(toContainerSession);
    this.startSceneByCallInner(isFirstCall, toInfo, toContainerSession, toSceneSession, topActiveSceneSession);
  }

  private updateWindowDragHotArea(persistentId: number): void {
    const sceneSession = this.getSceneSessionByPersistentId(persistentId);
    if (sceneSession === null) {
      this.log.showWarn(`scene session not find, persistentId: ${persistentId}`);
      return;
    }
    this.layoutPolicy.updateWindowDragHotArea(sceneSession);
  }

  private switchSplitScene(persistentId: number): void {
    const containerSession: SCBSceneContainerSession | null =
      this.getSceneContainerSessionWithPersistentId(persistentId);
    if (containerSession === null || !containerSession.isSplit) {
      this.log.showError('switchSplitScene containerSession is null or not split');
      return;
    }
    this.layoutPolicy.switchSplitSideDirectly(containerSession);
  }

  private updateSubSessionWhenRelativeToParent(sceneSession: SCBSceneSession): void {
    this.log.info('updateSubSessionWhenRelativeToParent');
    sceneSession.subSessionList.forEach((item) => {
      item.notifyParentRectChange(sceneSession.currRect, sceneSessionManager.SessionSizeChangeReason.UNDEFINED,
        sceneSession.sceneInfo.screenId);
    });
  }

  private isRequestHorizontalOrientation(requestedOrientation?: number): boolean {
    this.log.showInfo(`Request Orientation:${requestedOrientation}`);
    return requestedOrientation === SCBSceneOrientation.HORIZONTAL ||
      requestedOrientation === SCBSceneOrientation.REVERSE_HORIZONTAL ||
      requestedOrientation === SCBSceneOrientation.SENSOR_HORIZONTAL ||
      requestedOrientation === SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED ||
      requestedOrientation === SCBSceneOrientation.USER_ROTATION_LANDSCAPE ||
      requestedOrientation === SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED;
  }

  private recoverPosBySpecifiedFlag(scbSceneSession: SCBSceneSession) {
    if (!scbSceneSession || !scbSceneSession.sceneInfo) {
      this.log.showError(`SceneInfo is undefined`);
      return;
    }
    let info = scbSceneSession.sceneInfo;
    let abilityKey: string = info.bundleName + info.moduleName + info.abilityName;
    let specifiedFlag: string = info.specifiedFlag ?? '';
    if (!SCBPcScenePanelManager.getInstance().getIsEnableSpecifiedRectAutoSaveMap(abilityKey) ||
      specifiedFlag.length === 0) {
      this.log.showInfo(`The specifiedFlag is disabled`);
      return;
    }
    this.setSystemOrSupportAppWindowRectAutoSave(scbSceneSession);
    this.setIsWindowRectAutoSave(scbSceneSession);
    let isWhitelistApp: boolean = this.isWhitelistApp(scbSceneSession);
    if (!isWhitelistApp && !info.windowTop && !info.windowLeft && !info.windowWidth &&
      !info.windowHeight) {
      if (this.recoverPosIfNeeded(scbSceneSession)) {
        scbSceneSession.isRecoveredScene = true;
        this.log.showInfo(`recover cascade pos and size with the scene memory info by specified, ` +
          `width: ${scbSceneSession.currRect.width.getPx()}, height: ${scbSceneSession.currRect.height.getPx()}, ` +
          `translateX: ${scbSceneSession.currRect.left.getPx()}, translateY: ${scbSceneSession.currRect.top.getPx()},`);
        return;
      }
      let key: string = SCBPcScenePanelManager.getInstance().createIsWindowRectAutoSaveKey(info);
      if (SCBPcScenePanelManager.getInstance().getIsWindowRectAutoSaveMap(key)) {
        let persistentId: number = scbSceneSession.session.persistentId;
        if (this.checkMultiInstances(key, persistentId)) {
          this.setSizeAndPositionForMultiInstances(scbSceneSession);
        }
      }
    }
  }

  private abnormalRecoverContainerSession(sceneSession: sceneSessionManager.SceneSession,
    sceneInfo: sceneSessionManager.SceneRecoverInfo): void {
    if (sceneSession === null || sceneInfo === null) {
      this.log.showInfo('[WMSRecover] sceneSession or sceneInfo is null');
      return;
    }
    this.log.showInfo(`[WMSRecover] Recover callback content ====> windowMode: ${sceneInfo.windowMode},` +
      ` bundleName: ${sceneInfo.bundleName}, abilityName: ${sceneInfo.abilityName},` +
      ` persistentId: ${sceneSession.persistentId}, moduleName: ${sceneInfo.moduleName}`);
    let scbSceneInfo = new SCBSceneInfo(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName,
      sceneInfo.appIndex, sceneSession.persistentId);
    scbSceneInfo.screenId = sceneSession.screenId;
    scbSceneInfo.label = SCBSceneSessionManager.getInstance().getScenePersistent()
      .getCacheSessionLabel(sceneSession.persistentId);
    scbSceneInfo.updateWindowModeAndSync(sceneInfo.windowMode as SCBSceneMode);
    scbSceneInfo.supportWindowModes = sceneInfo.supportWindowModes;
    let scbSceneSession = new SCBSceneSession(sceneSession, scbSceneInfo);
    if (scbSceneSession == null) {
      this.log.showError(`[WMSRecover] Failed to recover PersistentId=${sceneSession.persistentId},` +
        ` scbSceneSession is null!`);
      return;
    }

    let sceneContainerSession = new SCBSceneContainerSession(scbSceneSession, this.screenProperty);
    sceneContainerSession.initAll();
    if (sceneInfo.sessionState === sceneSessionManager.SessionState.STATE_ACTIVE) {
      scbSceneSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_ACTIVE;
      sceneContainerSession.requestActivation(false, ActiveReason.RECOVER);
    }
    if (sceneInfo.windowMode === AbilityConstant.WindowMode.WINDOW_MODE_FULLSCREEN) {
      this.initCascadePosAndSize(scbSceneSession);
      scbSceneSession.layoutFullScreen = sceneInfo.layoutFullScreen;
      scbSceneSession.currRect.setRectNum(sceneInfo.recoverRect.posX_, sceneInfo.recoverRect.posY_,
        sceneInfo.recoverRect.width_, sceneInfo.recoverRect.height_);
      scbSceneSession.maximize();
      const HALF = 2;
      const DEFAULT_RATIO = 0.67;
      const recoverLastWidth = new ScbNumber(sceneInfo.recoverRect.width_ * DEFAULT_RATIO);
      const recoverLastHeight = new ScbNumber(sceneInfo.recoverRect.height_ * DEFAULT_RATIO);
      const recoverLastLeft = new ScbNumber(sceneInfo.recoverRect.posX_ +
        (1 - DEFAULT_RATIO) * sceneInfo.recoverRect.width_ / HALF);
      const recoverLastTop = new ScbNumber(sceneInfo.recoverRect.posY_ +
        (1 - DEFAULT_RATIO) * sceneInfo.recoverRect.height_ / HALF);
      sceneContainerSession.primarySession?.lastRect.setRect(recoverLastLeft, recoverLastTop,
        recoverLastWidth, recoverLastHeight);
    } else if (sceneInfo.windowMode === AbilityConstant.WindowMode.WINDOW_MODE_FLOATING) {
      scbSceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      sceneSessionManager.updateMaximizeMode(sceneSession.persistentId, false);
      this.initCascadePosAndSize(scbSceneSession, sceneInfo.recoverRect);
    } else { // change other window mode to floating
      scbSceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      this.initCascadePosAndSize(scbSceneSession);
    }
    if (scbSceneSession.isMainWindowTopmost !== sceneInfo.mainWindowTopmost) {
      this.log.showInfo(`recoverSessionMainWindowTopmostChange, state: ${sceneInfo.mainWindowTopmost}`);
      scbSceneSession.isMainWindowTopmost = sceneInfo.mainWindowTopmost;
      SCBSceneSessionManager.getInstance().requestToTop(sceneSession.screenId, sceneSession.persistentId,
        SCBWindowRaiseReason.SET_TOPMOST);
    }
    this.addSceneContainerSession(sceneContainerSession, false);
  }

  private abnormalRecoverFinished(): void {
    const topContainerSession = this.containerSessionList.getTopActiveSession();
    if (topContainerSession !== null && topContainerSession.primarySession !== null) {
      this.raiseSceneToTop(topContainerSession);
      SCBSceneSessionManager.getInstance()
        .requestFocus(topContainerSession.primarySession.sceneInfo.persistentId, undefined, FocusChangeReason.MOVE_UP);
    }
    AppModel.getInstance().getAppList(() => {
      ResidentLayoutCacheMgr.getInstance().clearCacheAndInit(this.tag).then(() => {
        this.setRecentDataList(); // update dock view after abnormal recovery finished
      })
    });
  }

  private removeShowWhenLockedContainerList(): SCBSceneContainerSessionArray {
    let ret = new SCBSceneContainerSessionArray();
    for (let i = 0; i < this.containerSessionList.length; ) {
      let item = this.containerSessionList[i];
      if (item.isShowWhenLocked() && !item.primarySession?.isClosing && item.isActive) {
        this.containerSessionList.splice(i, 1);
        ret.push(item);
      } else {
        i += 1;
      }
    }
    if (ret.length > 0) {
      this.setRecentDataList();
      this.refreshZOrder();
    }
    return ret;
  }

  private onSplitPrimary(persistentId?: number, containerId?: number): void {
    this.onSplit(true, persistentId, containerId);
  }

  private onSplitSecondary(persistentId?: number, containerId?: number): void {
    this.onSplit(false, persistentId, containerId);
  }

  private onSplit(isPrimary: boolean, persistentId?: number, containerId?: number): void {
    this.log.showInfo(`onSplit with isPrimary:${isPrimary} persistentId:${persistentId} containerId:${containerId}`);
    let containerSession = this.getContainerWithPersistentIdOrContainerId(persistentId, containerId);
    if (!containerSession) {
      this.log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    if (!this.checkSupportSplit(containerSession, persistentId)) {
      return;
    }
    if (!containerSession.secondarySession) {
      this.log.showDebug('enable Split');
      if (containerSession.isSplit && containerSession.isSplitPrimaryMode() && isPrimary) {
        //若窗口当前已经在左分屏，准备再进行左分屏，就执行右预分屏，并修改多任务视图的区域
        isPrimary = false;
      } else if (containerSession.isSplit && !containerSession.isSplitPrimaryMode() && !isPrimary) {
        isPrimary = true;
      }
      if (this.containerSessionList.getTopActiveSession() !== containerSession) {
        this.log.showInfo('raise split container to top')
        this.raiseSceneToTop(containerSession);
      }
      containerSession.init();
      containerSession.dividerParam.init();
      this.panelProxy.setIsPairSplit(true);
      containerSession.dividerParam.isSplitPrimaryMode = isPrimary;
      containerSession.dividerParam.splitOrderIsNotReverse = isPrimary;
      containerSession.isSplit = true;
      this.panelProxy.getSysSceneSession().setExclusivelyHighlighted(false);
      this.panelProxy.updateScenePanelState(ScenePanelState.SPLIT);
      AnimateToScheduleUtils.reportSplitToRss(SplitStatus.ENTER_SPLIT,
        containerSession.primarySession?.sceneInfo.bundleName);
      isPrimary ? containerSession.primarySession?.splitPrimary() : containerSession.primarySession?.splitSecondary();
      this.panelProxy.enterSplitView(containerSession, isPrimary);
      this.resetWindowEffect(containerSession);
    } else {
      if (persistentId === undefined) {
        persistentId = -1;
      }
      this.layoutPolicy.switchSplitSideWithCondition(isPrimary, containerSession, persistentId);
    }
  }

  private checkSupportSplit(containerSession: SCBSceneContainerSession, persistentId?: number): boolean {
    let sceneSession = containerSession.primarySession?.sceneInfo.persistentId === persistentId ?
      containerSession.primarySession : containerSession.secondarySession;
    if (sceneSession?.isClosing) {
      this.log.showError(`onSplit scene session is closing persistentId: ${persistentId}`);
      return false;
    }
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      this.log.showError('onSplit screen is locked');
      return false;
    }
    return true;
  }

  private onMinimizeScene(persistentId?: number, containerId?: number, extraInfo?: ExecuteCallbackExtraInfo) {
    this.log.showInfo(`[SCBMain]onMinimizeScene with persistentId:${persistentId} containerId:${containerId}`);
    const containerSession = this.getContainerWithPersistentIdOrContainerId(persistentId, containerId);
    if (!containerSession) {
      this.log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    if (!containerSession.isActive) {
      this.log.showWarn(`containerSession is already background:${persistentId}`);
      if (extraInfo && extraInfo.isMinimizeFromSetParentSession) {
        this.doAnimateOutFromSetParentSession(containerSession, extraInfo);
      }
      return;
    }

    if (this.isInPanelState(ScenePanelState.RECENT)) {
      this.panelProxy.minimizeSceneInRecent(containerSession);
      return;
    }
    if (containerSession.isSplit) {
      this.exitSplitOnMinimize(persistentId);
    } else {
      AnimateToScheduleUtils.reportMinimizeToRss(containerSession?.primarySession?.sceneInfo.bundleName);
      this.onSceneMinimize(containerSession, extraInfo);
    }
  }

  private exitSplitOnMinimize(persistentId: number | undefined): void {
    let param = new ExitSplitParam();
    param.needExitSplitRecent = this.isSplitState();
    param.exitSplitEvent = SCBSessionEventId.EVENT_MINIMIZE;
    param.needRaise = false;
    this.pcExitSplitCommand = MonitorExitSplitName.MINIMIZE;
    this.exitSplitView(persistentId, param);
  }

  private onSceneMinimize(sceneContainerSession: SCBSceneContainerSession,
    extraInfo?: ExecuteCallbackExtraInfo): void {
    this.log.showInfo(`[SCBMain]onSceneMinimize name: ${sceneContainerSession.getName()}`);
    let primarySession = sceneContainerSession.primarySession;
    if (!primarySession || primarySession.isMinimizing) {
      return;
    }

    // minimize scene animation
    SCBFreeWindowsDfx.getInstance().minimizeStart(sceneContainerSession.companionIconInfo?.bundleName);
    AnimateToScheduleUtils.raiseResizeWindow(AnimateToScheduleUtils.VALUE_START);
    primarySession.isMinimizing = true;

    let iconRect: RectInfo = new RectInfo();
    const appItem = this.getAppInfoFromDock(sceneContainerSession, extraInfo);
    let hasIcon: boolean = (appItem !== undefined && appItem !== null);
    const context: UIContext = this.getUiContext();
    if (appItem) {
      iconRect = this.getIconRect(appItem);
      this.isHide = this.isHideOnDock(appItem);
    }
    let newRect = primarySession.currRect.copy();
    this.log.showInfo(`[SCBMain]minimize scene item: ${appItem?.abilityName}, iconRect: [${iconRect.left}, ` +
      `${iconRect.top}, ${iconRect.right}, ${iconRect.bottom}] screenDensityDpi: ${this.screenDpiDensity}`);
    const sceneWidth = SCBSystemSceneUtils.getInstance().px2vp(context, newRect.width.getPx());
    const sceneHeight = SCBSystemSceneUtils.getInstance().px2vp(context, newRect.height.getPx());
    const sceneTransX = SCBSystemSceneUtils.getInstance().px2vp(context, newRect.left.getPx());
    const sceneTransY = SCBSystemSceneUtils.getInstance().px2vp(context, newRect.top.getPx());
    const iconWidth = iconRect.right - iconRect.left;
    const iconHeight = iconRect.bottom - iconRect.top;
    const sceneCenterPosX = sceneTransX + sceneWidth / 2;
    const sceneCenterPosY = sceneTransY + sceneHeight / 2;
    const dockHeight = SCBSystemSceneUtils.getInstance().getDockHeightVP(context, this.screenProperty.screenId);
    const iconTransX = (iconRect.left + iconRect.right) / 2;
    const iconTransY = SCBSystemSceneUtils.getInstance().px2vp(context, this.screenProperty.height) - dockHeight;
    const centerTranX = sceneCenterPosX - (iconRect.left + iconWidth / 2);
    const centerTranY = sceneCenterPosY - (iconRect.top + iconHeight / 2);
    hasIcon = hasIcon && ((iconWidth !== 0) && (iconHeight !== 0));
    const iconTransAlpha = this.APP_ICON_TRANS_ALPHA;
    const sceneTransAlpha = this.SCENE_TRAN_ALPHA;
    const sceneInitSize = (1.0 + 0.5 * (1.0 - sceneTransAlpha) / iconTransAlpha) * iconWidth;
    const sceneEndScale = sceneInitSize / Math.min(sceneWidth, sceneWidth);
    const sceneRadius = primarySession.floatBorderRadius * (this.screenDpiDensity / 160);
    const sceneEndScaleX = iconWidth / sceneWidth;
    const sceneEndScaleY = iconHeight / sceneHeight;
    let sceneEndTranX = hasIcon ? -centerTranX :
      (SCBSystemSceneUtils.getInstance().px2vp(context, this.screenProperty.width) * 0.5 - sceneCenterPosX);
    let sceneEndTranY = hasIcon ? -centerTranY :
      (SCBSystemSceneUtils.getInstance().px2vp(context, this.screenProperty.height) * 0.75 - sceneCenterPosY);
    this.log.showInfo('scene minimize src state[scale:' + primarySession.scaleX + ', opacity:' +
    primarySession.opacity + ', tranX:' + primarySession.translateX + ', tranY:' + primarySession.translateY + ']');
    sceneContainerSession.addTransitionCount();
    const animationCnt = sceneContainerSession.getTransitionCount();
    const canDoAttractionAnim = this.canDoAttractionAnim();
    const doAttractionAnim: boolean = hasIcon && canDoAttractionAnim;
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_MIN_WINDOW, !doAttractionAnim);
    sceneContainerSession.requestBackground(false, false, false);
    if (!(doAttractionAnim && primarySession.isAttracting)) {
      sceneContainerSession.primarySession?.saveSnapshotSync();
    }
    sceneContainerSession.isDisappearing = true;
    const sceneInfo = primarySession.sceneInfo;
    const transitionsContext = this.getTransitionsContextForIconAnimate(sceneInfo, extraInfo);
    const transitionController = SCBTransitionManager.getInstance().findTransitionController(transitionsContext[0],
      () => {
        const appData = PageDesktopModel.getInstance().getCloseAppData(transitionsContext[0],
          transitionsContext[1], StartType.DOCK_APP, null, null, sceneInfo.appIndex, null, sceneInfo?.appInstanceKey);
        appData.screenId = this.screenProperty.screenId;
        appData.persistentId = appItem?.persistentId ?? '';
        appData.appIndex = PCDockUtils.isDlpIndex(appData.appIndex ?? 0) ? 0 : appData.appIndex;
        return appData;
      });
    const key = this.getAppItemKey(transitionController);
    const shouldMinimizeToDock: boolean = this.shouldMinimizeToDock(sceneContainerSession);
    const doIconAnim = hasIcon && !canDoAttractionAnim && !this.isHide && appItem && shouldMinimizeToDock;
    this.log.showInfo(`onSceneMinimize animationCnt: ${animationCnt}, ` +
      `isIconInvisibleOnDock: ${this.isHide}, ` + `shouldMinimizeToDock: ${shouldMinimizeToDock}, ` +
      `isAttractionEnabled: ${canDoAttractionAnim}`);
    const finishCallback = () => {
      let currentAnimationCnt = sceneContainerSession.getTransitionCount();
      transitionController?.onInactive?.(this.tag, 'onMinimizeScene');
      this.log.showInfo(`onSceneMinimize onFinish: ${currentAnimationCnt}`);
      this.restoreSceneRadius(primarySession);
      if (animationCnt === currentAnimationCnt) {
        // restore scene initial translate, make it correct when start again
        this.log.showInfo('scene minimize transition animation finish.')
        if (doAttractionAnim) {
          primarySession!.isAttracting = false;
        }
        primarySession!.isMinimizing = false;
        primarySession!.isSessionResizeWhenDragEnd = false;
        sceneContainerSession.isDisappearing = false;
        sceneContainerSession.needRenderVisibility.setVisibilityWithDfx(false, this.tag, 'setVisibilityMinimizeSession',
          sceneContainerSession.getName());
        sceneContainerSession.clearTransitionCount();
        AppStorage.setOrCreate('isSplitAnimating', false);
        // set to init state to avoid multi scene start with error scene state
        if (!this.isRecentOrSplitState()) {
          primarySession?.initSceneState();
        }
        if (!doIconAnim) {
          performanceMonitor.end('WINDOW_TITLE_BAR_MINIMIZED');
          // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MIN, StyleConstants.DEFAULT_0);
          systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_MIN_WINDOW);
        }
      }
    };

    this.doSpecificSceneAnimateOut(primarySession, iconRect, hasIcon, sceneEndScale);
    if (doAttractionAnim) {
      primarySession.attractionTransX = iconTransX - sceneTransX;
      primarySession.attractionTransY = iconTransY - sceneTransY;
      primarySession.attractionTransY -= this.fixAttractionTranslate();
      primarySession.isAttracting = true;
      primarySession.setOcclusionAlpha(0);
      primarySession.setSidebarBlur(false, false);
      const attractionValNum = 1;
      this.getUiContext()?.animateToImmediately({
        duration: 0,
        onFinish: finishCallback
      }, () => {
        primarySession!.attractionVal = attractionValNum;
      })
      this.getUiContext()?.animateTo({
        duration: 0,
        delay: 160
      }, () => {
        transitionController?.onActive?.(this.tag, 'onMinimizeScene: AttractionAnimation');
      })
      this.getUiContext()?.animateTo({
        duration: 0,
      }, () => {
        transitionController?.onInactive?.(this.tag, 'onMinimizeScene: AttractionAnimation');
      })
    } else {
      this.getUiContext()?.animateTo({
        duration: 0,
        onFinish: finishCallback
      }, () => {
        if (this.isHide) {
          primarySession!.setTran(sceneEndTranX, sceneEndTranY - dockHeight / 4);
        } else {
          primarySession!.setTran(sceneEndTranX, sceneEndTranY);
        }
      })
      this.getUiContext()?.animateTo({
        duration: 0,
      }, () => {
        primarySession!.floatBorderRadius = CommonConstants.DEFAULT_ICON_RADIUS / sceneEndScale;
      })
      if (!this.isBottomInBScreen(primarySession)) {
        if (this.isHide) {
          this.getUiContext()?.animateTo({
            duration: 0,
          }, () => {
            primarySession!.opacity = 0;
          })
          this.getUiContext()?.animateTo({
            duration: 0,
          }, () => {
            primarySession!.setScale(0, 0);
          })
        } else {
          this.getUiContext()?.animateTo({
            duration: 0,
          }, () => {
            primarySession!.setScaleX(sceneEndScaleX);
          })
          this.getUiContext()?.animateTo({
            duration: 0,
          }, () => {
            primarySession!.setScaleY(sceneEndScaleY);
          })
          this.getUiContext()?.animateTo({
            duration: 0,
          }, () => {
            primarySession!.opacity = 0;
          })
          if (transitionController?.appData?.startAppType === StartType.DOCK_APP) {
            this.getUiContext()?.animateTo({
              duration: 0,
            }, () => {
              transitionController?.onActive?.(this.tag, 'onMinimizeScene');
            })
          }
        }
      } else {
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          primarySession!.setScale(sceneEndScale, sceneEndScale);
        })
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          primarySession!.opacity = 0;
        })
        if (transitionController?.appData?.startAppType === StartType.DOCK_APP) {
          this.getUiContext()?.animateToImmediately({
            duration: 0,
          }, () => {
            transitionController?.onActive?.(this.tag, 'onMinimizeScene');
          })
        }
      }
    }
    this.log.showInfo('scene minimize dst state[attraction:' + doAttractionAnim +
      ', scale:' + primarySession.scaleX + ', opacity:' + primarySession.opacity +
      ', tranX:' + primarySession.translateX + ', tranY:' + primarySession.translateY + ']');

    if (this.isHide) {
      this.isHide = false;
    }
    AnimateToScheduleUtils.raiseResizeWindow(AnimateToScheduleUtils.VALUE_END);
  }

  private hasImmersiveWindow(sceneContainerSession: SCBSceneContainerSession): boolean {
    let hasImmersiveWindow: boolean = false;
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      let containerSession = this.containerSessionList[i];
      if (containerSession === null || !containerSession.isActive ||
        containerSession?.screenProperty?.screenId !== this.screenProperty?.screenId ||
        sceneContainerSession?.containerId === containerSession.containerId) {
        continue;
      }
      let isFullScreen = containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN;
      let isSplit = containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY ||
        containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY;
      // icons need to show in fullScreen or split.
      if ((!containerSession.primarySession?.layoutFullScreen && isFullScreen) || isSplit) {
        break;
      } else if (containerSession.primarySession?.layoutFullScreen &&
        !this.isBottomInBScreen(containerSession.primarySession) && !viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK)) {
        hasImmersiveWindow = true;
        break;
      }
    }
    return hasImmersiveWindow;
  }

  private doSpecificSceneAnimateOut(primarySession: SCBSceneSession, iconRect: RectInfo,
    hasIcon: boolean, sceneEndScale: number): void {
    if (!primarySession) {
      this.log.showError('doSpecificSceneAnimateOut primarySession is null');
      return;
    }
    let specificSceneList: SCBSpecificSession[] = [];
    let dialogSceneList = primarySession.dialogSessionList;
    let subSceneList = primarySession.subSessionList;
    specificSceneList.push(...dialogSceneList as (SCBSpecificSession)[]);
    if (subSceneList !== null) {
      SCBSceneHelper.traverseSubList(subSceneList, specificSceneList);
    }
    if (specificSceneList.length > 0) {
      this.log.showInfo(`doSpecificSceneAnimateOut specificSceneList.length: ${specificSceneList.length}`);
      for (let i = 0; i < specificSceneList.length; i++) {
        const specificScene = specificSceneList[i];
        const sceneWidth = specificScene.currRect.width.getVp();
        const sceneHeight = specificScene.currRect.height.getVp();
        const iconWidth = iconRect.right - iconRect.left;
        const iconHeight = iconRect.bottom - iconRect.top;
        const sceneCenterPosX = specificScene.currRect.left.getVp() + sceneWidth / 2;
        const sceneCenterPosY = specificScene.currRect.top.getVp() + sceneHeight / 2;
        const centerTranX = sceneCenterPosX - (iconRect.left + iconWidth / 2);
        const centerTranY = sceneCenterPosY - (iconRect.top + iconHeight / 2);
        let sceneEndTranX = 0;
        let sceneEndTranY = 0;
        sceneEndTranX = hasIcon ? -centerTranX : (SCBSystemSceneUtils.getInstance().px2vp(
          this.getUiContext(), this.screenProperty.width) * 0.5 - sceneCenterPosX);
        sceneEndTranY = hasIcon ? -centerTranY : (SCBSystemSceneUtils.getInstance().px2vp(
          this.getUiContext(), this.screenProperty.height) * 0.75 - sceneCenterPosY);
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          specificScene.translateX = sceneEndTranX;
          specificScene.translateY = sceneEndTranY;
        })
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          specificScene.scaleX = sceneEndScale;
        })
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          specificScene.scaleY = sceneEndScale;
        })
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          this.setSpecSceneOpacity(specificScene, 0.0);
        })
      }
    }
  }

  private onMaximizeScene(persistentId?: number, containerId?: number, isMaximizeFullScreen = false) {
    this.log.showInfo(`[SCBMain]onMaximizeScene with persistentId:${persistentId} containerId:${containerId} ` +
      `isMaximizeFullScreen: ${isMaximizeFullScreen}`);
    let currContainerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    if (!currContainerSession) {
      this.log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    ;
    if (!(currContainerSession.isActive || currContainerSession.isSplit)) {
      this.log.showWarn(`containerSession is already background:${persistentId}`);
      this.doMaximizeBackgroundScene(currContainerSession);
      return;
    }
    if (currContainerSession.isSplit) {
      // maximize current split container
      if (currContainerSession.primarySession) {
        let param = new ExitSplitParam();
        param.needExitSplitRecent = !currContainerSession.secondarySession;
        param.exitSplitEvent = SCBSessionEventId.EVENT_MAXIMIZE;
        this.pcExitSplitCommand = MonitorExitSplitName.MAXIMIZE;
        this.exitSplitView(persistentId, param);
        let containerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
        if (containerSession) {
          currContainerSession = containerSession;
        }
      } else {
        currContainerSession.initAll();
      }
    } else {
      let isTopmostContainerSession: boolean = currContainerSession.isTopmost();
      AnimateToScheduleUtils.reportMaximizeToRss(WindowPanelType.MAXIMIZE,
        currContainerSession?.primarySession?.sceneInfo.bundleName);
      if (isMaximizeFullScreen) {
        currContainerSession.primarySession?.maximizeFullScreen(true);
      } else {
        currContainerSession.primarySession?.maximize();
      }
      if (isTopmostContainerSession) {
        // sort and refresh z order if current session is topmost before maximization
        this.containerSessionList.sortByTopmost();
        this.refreshZOrder();
      }
    }
    if (!this.isRecentState()) {
      currContainerSession.init();
      this.resetWindowEffect(currContainerSession);
    }
  }

  private getTransitionsContextForIconAnimate(sceneInfo: SCBSceneInfo, extraInfo?: ExecuteCallbackExtraInfo): string[] {
    // 窗口最小化流程, 如果是回收站窗口则以dock回收站图标为锚点
    const isRecycleBin = this.panelProxy.isRecycleBin(sceneInfo, extraInfo);
    this.log.showInfo(`getTransitionsContextForIconAnimate bundleName: ${sceneInfo.bundleName}, ` +
      `isRcycleBin: ${isRecycleBin}`);
    if (!isRecycleBin) {
      return [sceneInfo.bundleName, sceneInfo.abilityName];
    } else {
      return [CommonConstants.LAUNCHER_BUNDLE, CommonConstants.RECYCLE_BIN_ABILITY];
    }
  }

  private doMaximizeBackgroundScene(container: SCBSceneContainerSession): void {
    if (!container || container.isActive || !container.primarySession) {
      return;
    }
    if (container.isSplit) {
      this.log.showInfo(`doMaximizeBackgroundScene is split return`);
      return;
    }
    this.log.showInfo(`doMaximizeBackgroundScene containerSession: ${container.getName()}, ` +
      `layoutFullScreen: ${container.primarySession?.layoutFullScreen}`);
    let scene: SCBSceneSession = container.primarySession;
    // 从自由多窗迁移过来的窗口使用窗口启动规则计算一次
    if (container.isPendingResizeInPcMode) {
      this.initCascadePosAndSize(scene);
      scene.saveLastRect();
    }
    this.maximizeScene(scene);
    container.sessionData.isPendingResizeInPcMode = false;
    scene.resetLastEventId();
    if (this.isRecentState()) {
      this.panelProxy.sessionRectChangeInRecent();
    } else {
      container.init();
    }
  }

  private maximizeScene(sceneSession: SCBSceneSession): void {
    if (!sceneSession) {
      this.log.showWarn('scene or screenProperty is invalid return');
      return;
    }
    this.log.showInfo(`maximizeScene, scene: ${sceneSession.sceneInfo.persistentId}, ` +
      `layoutFullScreen: ${sceneSession.layoutFullScreen}`);
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING && !sceneSession.isMaximizeFloating) {
      sceneSession.saveLastRect();
    }
    let screenInfo = this.getRealScreenInfo(sceneSession.currRect.top.getPx());
    let newCurrRect = this.UpdateOutScreenRect(sceneSession.lastRect, screenInfo);
    sceneSession.lastRect.setRect(newCurrRect.left, newCurrRect.top, newCurrRect.width, newCurrRect.height);
    let dockHeight = SCBSystemSceneUtils.getInstance().getDockHeightPx(this.screenId, this.getUiContext());
    let statusBarHeight = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenId);
    sceneSession.session.setWindowLastSafeRect(sceneSession.lastRect.left.getPx(), sceneSession.lastRect.top.getPx(),
      sceneSession.lastRect.width.getPx(), sceneSession.lastRect.height.getPx());
    sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
    sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    let posY = 0;
    let height = 0;
    if (sceneSession.layoutFullScreen) {
      this.log.showInfo(`maximizeScene layoutFullScreen isNotfoldMachine`);
      posY = 0;
      height = this.getFullScreenWindowHeight(sceneSession);
    } else {
      sceneSession.isRecoveredScene = true;
      posY = screenInfo.maxTop;
      height = screenInfo.screenHeightLimit;
      sceneSession.isRecoveredFullScreen = true;
    }
    sceneSession.floatBorderRadius = 0;
    sceneSession.currRect.setPosNum(0, posY);
    sceneSession.currRect.setSizeNum(screenInfo.screenWidth, height);
  }

  private onMaximizeFloatingScene(persistentId?: number, containerId?: number) {
    this.log.showInfo(`[SCBMain]onMaximizeFloatingScene with persistentId:${persistentId} containerId:${containerId}`);
    const currContainerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    if (!currContainerSession) {
      this.log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    if (!currContainerSession.isActive) {
      this.log.showWarn(`containerSession is already background:${persistentId}`);
      return;
    }
    for (let container of this.containerSessionList) {
      if (container.containerId === currContainerSession.containerId) {
        if (currContainerSession.isSplit) {
          // maximize floating current split container
          if (currContainerSession.primarySession && currContainerSession.secondarySession) {
            const exitSceneSession = currContainerSession.primarySession.session.persistentId === persistentId ?
            currContainerSession.secondarySession : currContainerSession.primarySession;
            this.exitSplitView(exitSceneSession.session.persistentId);
            this.log.showDebug(`exitSplitView exit session:${exitSceneSession.session.persistentId}`);
          }
        }
      }
    }
  }

  private onCloseScene(persistentId?: number, containerId?: number, isSaveSnapshot?: boolean,
    extraInfo?: ExecuteCallbackExtraInfo): void {
    this.onCloseSceneInner(persistentId, containerId, false, isSaveSnapshot, extraInfo);
  }

  private onTerminateScene(persistentId?: number, containerId?: number, extraInfo?: ExecuteCallbackExtraInfo): void {
    this.log.showInfo(`[SCBMain]onTerminateScene with persistentId:${persistentId} containerId:${containerId} ` +
      `scenePanelState:${this.getScenePanelState()}`);
    // get current containerSession
    const containerSession = this.getContainerWithPersistentIdOrContainerId(persistentId, containerId);
    const isException = false;
    const isSaveSnapshot = true;
    if (!containerSession) {
      this.log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      this.onCloseSceneInner(persistentId, containerId, isException, isSaveSnapshot, extraInfo);
      return;
    }
    const sceneSession: SCBSceneSession | null = persistentId ? this.getSceneSessionByPersistentId(persistentId) : null;
    if (!sceneSession) {
      this.log.showError(`cannot find sceneSession with persistentId:${persistentId}`);
      this.onCloseSceneInner(persistentId, containerId, isException, isSaveSnapshot, extraInfo);
      return;
    }
    if (this.shouldInterruptTerminateForBackGesture(containerSession, extraInfo?.errorReason)) {
      this.onMinimizeScene(persistentId);
      return;
    }
    const sceneInfo: SCBSceneInfo = sceneSession.sceneInfo;
    this.log.showInfo(`sceneInfo.callerPersistentId:${sceneInfo?.callerPersistentId}`);
    // if sceneInfo.callerPersistentId is 0, the app is not started by other app, need return to desktop
    if (sceneInfo === null || sceneInfo.callerPersistentId === 0) {
      this.onCloseSceneInner(persistentId, containerId, isException, isSaveSnapshot, extraInfo);
      return;
    }
    // get caller containerSession. if caller is in full screen, start a full screen session, caller will minimize
    const callerContainerSession: SCBSceneContainerSession | null = this.getSceneContainerSessionWithPersistentId(
      sceneInfo.callerPersistentId);
    if (callerContainerSession === null || sceneInfo.callerPersistentId === persistentId) {
      this.onCloseSceneInner(persistentId, containerId, isException, isSaveSnapshot, extraInfo);
      return;
    }
    this.onCloseSceneInner(persistentId, containerId, isException, isSaveSnapshot, extraInfo);
  }

  private onSceneRaiseToTop(persistentId?: number, containerId?: number, reason?: SCBWindowRaiseReason) {
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `onRaiseSceneToTop with persistentId:${persistentId} ` +
      `containerId:${containerId} reason:${reason}`);
    let containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    if (!containerSession) {
      WinLog.showError(WinLogDomain.WMS_HIERARCHY, `cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
    if (!this.isOldContainerAndRecentState(containerSession)) {
      this.raisePresentSceneToTop(containerSession, persistentId, reason);
    }
    if (this.isInPanelState(ScenePanelState.RECENT) && !containerSession.isActive) {
      return;
    } else if (this.isInPanelState(ScenePanelState.SPLIT)) {
      let splitSceneSession: SCBSceneSession | null = null;
      for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
        if (this.containerSessionList[i].isSplit && !this.containerSessionList[i].secondarySession) {
          splitSceneSession = this.containerSessionList[i].primarySession;
          break;
        }
      }
      if (splitSceneSession && splitSceneSession.sceneInfo.persistentId !==
        containerSession.primarySession?.sceneInfo.persistentId) {
        this.exitSplitView(splitSceneSession.sceneInfo.persistentId);
        containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
        this.getSceneContainerSessionWithContainerId(containerId);
        if (containerSession?.primarySession?.sceneInfo.persistentId) {
          this.raiseSceneToTop(containerSession);
          SCBSceneSessionManager.getInstance()
            .requestFocus(containerSession.primarySession.sceneInfo.persistentId, undefined, FocusChangeReason.MOVE_UP);
        }
        return;
      }
    }
  }

  private onRaiseMainWindowAboveTarget(persistentId?: number, targetPersistentId?: number) {
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `raiseMainWindowAboveTarget, sourcePersistentId: ${persistentId}, targetPersistentId:${targetPersistentId}`);
    if (!this.containerSessionList) {
      WinLog.showError(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget failed, containerSessionList is null');
      return;
    }
    const sourceIndex = this.containerSessionList.findIndex(container => {
      return (container.primarySession?.session?.persistentId === persistentId ||
              container.secondarySession?.session?.persistentId === persistentId);
    });
    const targetIndex = this.containerSessionList.findIndex(container => {
      return (container.primarySession?.session?.persistentId === targetPersistentId ||
              container.secondarySession?.session?.persistentId === targetPersistentId);
    });
    if (sourceIndex === -1 || targetIndex === -1) {
      WinLog.showError(WinLogDomain.WMS_HIERARCHY, `raiseMainWindowAboveTarget failed, sourceIndex: ${sourceIndex}, targetIndex: ${targetIndex}`);
      return;
    }
    const sourceContainerSession = this.containerSessionList[sourceIndex];
    const targetContainerSession = this.containerSessionList[targetIndex];
    const focusSessionId: ESObject = SCBSceneSessionManager.getInstance().getFocusedSession()?.session?.persistentId;
    const focusedIndex = this.containerSessionList.findIndex(container => {
      return (container.primarySession?.session?.persistentId ===
              SCBSceneSessionManager.getInstance().findMainSessionById(focusSessionId)?.session?.persistentId) ||
             (container.secondarySession?.session?.persistentId ===
              SCBSceneSessionManager.getInstance().findMainSessionById(focusSessionId)?.session?.persistentId);
    });
    if (focusedIndex === -1) {
      WinLog.showError(WinLogDomain.WMS_HIERARCHY, `raiseMainWindowAboveTarget failed, focusedIndex: ${focusedIndex}`);
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `raiseMainWindowAboveTarget, sourceIndex ${sourceIndex}, targetIndex:${targetIndex}, focusedIndex:${focusedIndex}`);

    //raising within the same split view
    if (sourceIndex === targetIndex && persistentId !== targetPersistentId) {
      if (!sourceContainerSession.isSplit) {
        WinLog.showError(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget failed, split state abnormal');
        return;
      }
      const isPrimaryRaise = sourceContainerSession.dividerParam.isPrimaryRaise;
      const isPrimaryRaiseAboveTarget = sourceContainerSession.primarySession?.session?.persistentId === persistentId;
      if ((isPrimaryRaise && isPrimaryRaiseAboveTarget) || (!isPrimaryRaise && !isPrimaryRaiseAboveTarget)) {
        WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget, split view higher session no need to raise');
        return;
      }
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget, split view hierarchy reverse');
      sourceContainerSession.dividerParam.setPrimaryZIndex(isPrimaryRaise ? 0 : -1);
      sourceContainerSession.dividerParam.setSecondaryZIndex(isPrimaryRaise ? -1 : 0);
      this.refreshZOrder();
      if (focusedIndex === sourceIndex) {
        WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget, request focus');
        SCBSceneSessionManager.getInstance().requestFocus(persistentId, false, FocusChangeReason.MOVE_UP);
      }
      return;
    }

    //raising between different containers
    if (targetIndex === sourceIndex || targetIndex + 1 === sourceIndex) {
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget, session no need to raise');
      return;
    }
    const insertIndex = targetIndex > sourceIndex ? targetIndex : targetIndex + 1;
    this.containerSessionList.splice(sourceIndex, 1);
    this.containerSessionList.spliceAndInsert(insertIndex, 0, sourceContainerSession);
    this.refreshZOrder();
    if (sourceIndex < focusedIndex && focusedIndex <= targetIndex) {
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget, request focus');
      SCBSceneSessionManager.getInstance().requestFocus(persistentId, false, FocusChangeReason.MOVE_UP);
    } else if (targetIndex < sourceIndex - 1 && focusedIndex === sourceIndex) {
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, 'raiseMainWindowAboveTarget, lose focus');
      SCBSceneSessionManager.getInstance()
        .requestFocus(this.containerSessionList.getTopActiveSession()?.primarySession?.persistentId,
                      false, FocusChangeReason.MOVE_UP);
    }
  }

  /**
   * 判断当前ContainerSession会话是否是已有会话，并判断当前SCBScenePanel是否为任务中心状态
   * @param sceneSession
   * @returns
   */
  private isOldContainerAndRecentState(containerSession: SCBSceneContainerSession): boolean {
    if (!containerSession) {
      return false;
    }
    return this.isInPanelState(ScenePanelState.RECENT) &&
      this.getSceneContainerSessionWithContainerId(containerSession.containerId) !== null;
  }

  private onSceneRecover(persistentId?: number, containerId?: number): void {
    this.log.showInfo(`[SCBMain]onSceneRecover with persistentId:${persistentId} containerId:${containerId}`);
    let containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    if (containerSession?.isSplit) {
      this.pcExitSplitCommand = MonitorExitSplitName.RECOVER;
      this.exitSplitView(persistentId);
      return;
    }
    if (!containerSession && persistentId !== undefined) {
      let containerSessionList = SCBSceneSessionManager.getInstance().getSpecialContainerSessionList();
      if (containerSessionList) {
        let index = containerSessionList.findIndex((item) => {
          return item.primarySession?.session.persistentId === persistentId;
        });
        if (index !== -1) {
          containerSession = containerSessionList[index]
        }
      }
    }
    containerSession?.primarySession?.recover();
    if (containerSession?.isTopmost()) {
      // raise containerSession to top if it is topmost after recover
      this.raiseSceneToTop(containerSession);
    }
  }

  private sceneHiddenStartFromOther(sceneInfo: SCBSceneInfo): void {
    this.onSceneHiddenModeVisChange(sceneInfo, false);
  }

  private sceneHiddenStartTransition(toInfo: SCBSceneInfo): void {
    this.onSceneHiddenModeVisChange(toInfo, false);
  }

  private sceneHiddenToForegroundFromOther(sceneInfo: SCBSceneInfo): void {
    this.onSceneHiddenModeVisChange(sceneInfo, true);
  }

  private sceneHiddenToForegroundTransition(toInfo: SCBSceneInfo, isFromClient?: boolean): void {
    this.onSceneHiddenModeVisChange(toInfo, true, isFromClient);
  }

  private sceneForegroundToHidden(sceneInfo: SCBSceneInfo, isFromClient?: boolean): void {
    this.onSceneHiddenModeVisChange(sceneInfo, false, isFromClient);
  }

  private onSceneHiddenModeVisChange(toInfo: SCBSceneInfo, visible?: boolean, isFromClient?: boolean): void {
    let toSceneSession = this.requestSceneSession(toInfo);
    if (toSceneSession == null) {
      this.log.showError('[SCBMain]onSceneHiddenModeVisChange Failed to get toSceneSession');
      return;
    }
    let toContainerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession.session?.persistentId);

    let isFirstCall = false;
    if (toContainerSession === null) {
      toContainerSession = new SCBSceneContainerSession(toSceneSession, this.screenProperty);
      isFirstCall = true;
    }

    this.log.showInfo(`onSceneHiddenModeVisChange isFirstCall:${isFirstCall} visible:${visible} ` +
      `persistentId:${toSceneSession.session?.persistentId} isFromClient:${isFromClient}`);
    if (visible) {
      if (this.isInPanelState(ScenePanelState.RECENT)) {
        this.exitRecentView();
      }
    }
    if (isFirstCall && visible) {
      this.log.showError('onSceneHiddenModeVisChange error condition');
      return;
    } else if (isFirstCall && !visible) {
      this.addSceneContainerSessionNotShowRecent(toContainerSession);
      toSceneSession.sessionData.isNewWant = true;
      SCBSceneSessionManager.getInstance().requestStartUIAbilityBySCB(toSceneSession.session);
    } else if (!isFirstCall && visible) {
      this.onSceneHiddenModeShowAgain(toContainerSession, toSceneSession, isFromClient);
      toSceneSession.sessionData.sceneSessionEverShown = true;
      this.log.showInfo(`onSceneHiddenModeVisChange: sceneSessionEverShown: ` +
        `${toSceneSession.sessionData.sceneSessionEverShown}`);
    } else if (!isFirstCall && !visible) {
      this.onSceneHiddenModeHideAgain(toContainerSession, toSceneSession, isFromClient);
    } else {
      this.log.showError('onSceneHiddenModeVisChange error condition');
      return;
    }
    this.sendAndSetRecentDataList(toContainerSession, false);
  }

  private onSceneHiddenModeShowAgain(toContainerSession: SCBSceneContainerSession,
    toSceneSession: SCBSceneSession, isFromClient: boolean = false): void {
    this.recoverOrMaximizeIfLastSplit(toContainerSession);
    if (this.makeSessionFollowFocus(toContainerSession, toSceneSession, isFromClient)) {
      this.log.showInfo('move containerSession to another screen for display.');
      return;
    }
    this.removeSceneContainerSessionNotShowRecent(toContainerSession);
    this.addSceneContainerSession(toContainerSession);
    this.resizeWhenStartSceneIfNeed(toContainerSession);
    const oldIsActive: boolean = toContainerSession.isActive;
    try {
      let isNewWantFalseLists: string[] = systemParameter.getSync(SHOWABILITY_ISNEWWANT, '').split(',');
      if (isNewWantFalseLists.includes(toSceneSession.sceneInfo.bundleName)) {
        toSceneSession.sessionData.isAbilityShown = true;
      }
    } catch (error) {
      this.log.showError(`get isnewwant bundleNeme fail, message: ${error.message}`);
    }
    toSceneSession.sessionData.isShowAbility = true;
    toContainerSession.requestActivation(!toSceneSession.sessionData.isAbilityShown);
    let requestFocusId: number | undefined = !toContainerSession.isSplit ?
      toContainerSession.primarySession?.session?.persistentId :
      toContainerSession.secondarySession?.session?.persistentId;
    this.recoverOrMaximizeIfLastSplit(toContainerSession);
    toContainerSession.init();
    if (!oldIsActive) {
      this.onExitActiveSplit()
    }
    this.raiseSceneToTopAsync(toContainerSession, requestFocusId ?? 0);
    this.log.showInfo(`isAbilityShown: ${toSceneSession.sessionData.isAbilityShown}` +
      `persistentId:${toSceneSession.session?.persistentId}`);
    // 三指上滑、多任务中心场景最小化窗口时，还原动画参数
    SCBSceneHelper.setSceneTranslate(toContainerSession, 0, 0);
    SCBSceneHelper.setSceneScale(toContainerSession, 1);
    SCBSceneHelper.setSceneOpacity(toContainerSession, 1);
    this.resetSpecificSceneTransition(toContainerSession);
    this.setSpecificSceneOpacity(toContainerSession, 1);
    toSceneSession.sessionData.isAbilityShown = true;
    // wechat临时方案，后续正式需求上线后清理对应代码
    const isWechat = this.checkIsWechat(toContainerSession)
    if (isWechat && !oldIsActive && !toContainerSession.isSplit) {
      this.applyNonTraceableSceneAnimate(toContainerSession);
    }
  }

  private checkIsWechat(containerSession: SCBSceneContainerSession) {
    if (containerSession.primarySession !== null &&
    ViewModelConstant.WECHAT_BUNDLE_NAME.includes(containerSession.primarySession.sceneInfo.bundleName)) {
      return true;
    }
    return false;
  }

  private onSceneHiddenModeHideAgain(toContainerSession: SCBSceneContainerSession,
    toSceneSession: SCBSceneSession, isFromClient: boolean = false): void {
    this.log.showInfo(`onSceneHidden ${toContainerSession?.getName()} ${toSceneSession?.getName()} ${isFromClient}`);
    let containerSession: SCBSceneContainerSession | null = toContainerSession;
    toSceneSession.sessionData.isAbilityShown = false;
    // 预分屏下,任务中心里的二分屏窗口调用调用HideAbility
    if (this.isInPanelState(ScenePanelState.SPLIT) && containerSession?.dividerParam.isSplitRecentPair) {
      this.closeSession = toSceneSession.session.persistentId;
      this.exitSplitForPairSplit(toSceneSession.session.persistentId, false);
      toSceneSession.sessionData.isLastSplit = true;
      const container = this.getSceneContainerSessionWithPersistentId(toSceneSession?.session?.persistentId);
      if (!container) {
        this.log.showError('SplitRecentPair containerSession is null');
        return;
      }
      this.panelProxy.handleHideCloseInRecent(container, toSceneSession, isFromClient);
      return;
    }
    //预分屏窗口调用HideAbility
    if (toContainerSession?.isSplit) {
      let param = new ExitSplitParam();
      param.needExitSplitRecent = this.isSplitState();
      param.exitSplitEvent = SCBSessionEventId.EVENT_MINIMIZE;
      param.needRaise = false;
      this.exitSplitView(toSceneSession?.session?.persistentId, param);
      toContainerSession.init();
      containerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession?.session?.persistentId);
      if (!containerSession) {
        this.log.showError('containerSession is null');
        return;
      }
      if (this.isInPanelState(ScenePanelState.RECENT)) {
        this.panelProxy.handleHideCloseInRecent(containerSession, toSceneSession, isFromClient);
      } else {
        this.doSceneHideInSceneHideMode(containerSession, toSceneSession, isFromClient);
      }
      return;
    }
    // 多任务中心预关闭时调用HideAbility
    if (this.isRecentOrSplitState()) {
      this.log.showInfo(`onSceneHiddenModeHideAgain in Recent`);
      if (containerSession === null) {
        this.log.showError(`containerSession is null`);
        return;
      }
      this.panelProxy.handleHideCloseInRecent(containerSession, toSceneSession, isFromClient);
      return;
    }
    this.doSceneHideInSceneHideMode(containerSession, toSceneSession, isFromClient);
  }

  private setSpecificSceneOpacity(scene: SCBSceneContainerSession, opacity: number) {
    const dialogSceneList: SCBSpecificSession[] = [];
    this.getSpecificSceneList(scene, dialogSceneList);
    for (const dialogScene of dialogSceneList) {
      dialogScene.opacity = opacity;
    }
  }

  private resetSpecificSceneTransition(scene: SCBSceneContainerSession): void {
    const dialogSceneList: SCBSpecificSession[] = [];
    this.getSpecificSceneList(scene, dialogSceneList);
    for (const dialogScene of dialogSceneList) {
      dialogScene.scaleX = 1;
      dialogScene.scaleY = 1;
      dialogScene.translateX = 0;
      dialogScene.translateY = 0;
    }
  }

  private getSpecificSceneList(scene: SCBSceneContainerSession, dialogSceneList: SCBSpecificSession[]) {
    if (scene.primarySession === null) {
      return;
    }

    dialogSceneList.push(...scene.primarySession?.dialogSessionList);
    if (scene.primarySession?.subSessionList) {
      SCBSceneHelper.traverseSubList(scene.primarySession.subSessionList, dialogSceneList);
    }
    if (scene.isSplit && scene.secondarySession) {
      dialogSceneList.push(...scene.secondarySession.dialogSessionList);
      if (scene.secondarySession?.subSessionList) {
        SCBSceneHelper.traverseSubList(scene.secondarySession.subSessionList, dialogSceneList);
      }
    }
  }

  private makeSessionFollowFocus(toContainerSession: SCBSceneContainerSession,
    toSceneSession: SCBSceneSession, isFromClient: boolean = false): boolean {
    if (toSceneSession === null || toSceneSession === undefined) {
      return false;
    }
    if (toContainerSession === null || toContainerSession === undefined) {
      return false;
    }
    if (toContainerSession.primarySession === null ||
      toContainerSession.primarySession === undefined) {
      return false;
    }
    if (!toSceneSession.sceneInfo.isScreenIdNotSpecified) {
      this.log.showDebug('isScreenIdNotSpecified is false');
      return false;
    }
    if (toSceneSession.sessionData.isNotFirstSceneHiddenModeShow) {
      this.log.showDebug('isNotFirstSceneHiddenModeShow is true');
      return false;
    }
    toSceneSession.sessionData.isNotFirstSceneHiddenModeShow = true;
    toContainerSession.primarySession.sessionData.isNotFirstSceneHiddenModeShow = true;
    const focusedSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null =
      SCBSceneSessionManager.getInstance().getFocusedSession();
    if (focusedSession === undefined || focusedSession === null) {
      this.log.showError('focusedSession is invalid');
      return false;
    }
    if (focusedSession instanceof SCBSystemSceneSession) {
      this.log.showDebug('systemSceneSession is not supported');
      return false;
    }
    const toSceneInfo: SCBSceneInfo = toSceneSession.sceneInfo;
    let focusedSceneInfo: SCBSceneInfo | undefined = undefined;
    let focusedScreenId: number = INVALID_SCREEN_ID;
    if (focusedSession instanceof SCBSceneSession) {
      focusedSceneInfo = focusedSession.sceneInfo;
      focusedScreenId = focusedSession.sceneInfo.screenId;
    } else {
      const mainSession: SCBSceneSession | null =
        SCBSceneSessionManager.getInstance().findMainSessionById(focusedSession.session.parentId);
      if (mainSession === null) {
        this.log.showError('mainSession is null');
        return false;
      }
      focusedSceneInfo = mainSession.sceneInfo;
      focusedScreenId = focusedSession.screenId;
    }
    if (toSceneInfo.isSameBundleWithMultiApp(focusedSceneInfo)) {
      if (focusedScreenId !== toSceneInfo.screenId) {
        SCBPcScenePanelManager.getInstance().moveContainerSessionToAnotherScreenForDisplay(
          toContainerSession, toSceneInfo.screenId, focusedScreenId, true, isFromClient);
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  private onCloseSceneInner(persistentId?: number, containerId?: number, isException?: boolean,
    isSaveSnapshot?: boolean, extraInfo?: ExecuteCallbackExtraInfo): void {
    let containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    this.checkScenePanelStateWhenCloseScene(containerSession, persistentId);
    this.log.showInfo(`[SCBMain]onCloseScene with persistentId:${persistentId} containerId:${containerId} ` +
      `isSaveSnapshot:${isSaveSnapshot}, screenId: ${this.screenProperty.screenId}`);
    if (this.isRecentOrSplitState()) {
      this.log.showInfo(`recentOrSplitClose ${persistentId}, ${containerId}, ${isException}, ${isSaveSnapshot}`);
      let containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
      this.getSceneContainerSessionWithContainerId(containerId);
      containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
      this.getSceneContainerSessionWithContainerId(containerId);
      const checkRes = this.preCheckForOnCloseScene(persistentId, containerSession, isException);
      if (!checkRes || !containerSession) {
        this.log.showWarn('preCheck not pass return');
        return;
      }
      this.saveSceneMemoryInfo(containerSession);
      this.panelProxy.recentOrSplitClose(containerSession, isException, isSaveSnapshot, extraInfo);
      return;
    }
    if (containerSession?.isSplit) {
      this.log.showInfo('split scene has been closed before this.')
      return;
    }
    containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    const checkRes = this.preCheckForOnCloseScene(persistentId, containerSession, isException);
    if (!checkRes || !containerSession) {
      return;
    }
    let primarySession = containerSession.primarySession;
    if (primarySession) {
      HiSysEventUtil.reportCloseWindowEvent(primarySession.sceneInfo.bundleName);
    }
    let time = systemDateTime.getTime(false);
    performanceMonitor.recordInputEventTime(performanceMonitor.ActionType.LAST_UP,
      performanceMonitor.SourceType.PERF_MOUSE_EVENT, time);
    performanceMonitor.begin('APP_EXIT_FROM_WINDOW_TITLE_BAR_CLOSED', performanceMonitor.ActionType.LAST_UP,
      containerSession.companionIconInfo?.bundleName);
    containerSession.addTransitionCount();

    this.saveSceneMemoryInfo(containerSession);
    this.playNormalCloseSceneAnimate(containerSession, isException, extraInfo);
    this.isCloseSplitScreen = false;
  }

  private playNormalCloseSceneAnimate(containerSession: SCBSceneContainerSession, isException?: boolean,
    extraInfo?: ExecuteCallbackExtraInfo): void {
    const destroyFn = () => {
      let isNotShow: boolean = this.containerSessionListNotShowRecent.indexOf(containerSession) >= 0;
      this.removeSceneContainerSession(containerSession);
      SCBPcScenePanelManager.getInstance().onMainSessionClosed(containerSession.containerId);
      if (isNotShow) {
        this.setRecentDataList(false);
      } else {
        this.setRecentDataList();
      }
      if (isException && extraInfo?.errorReason === 'appRecovery') {
        this.sessionTempList.insert(SessionTempListGroupNames.APP_RECOVER, containerSession);
      }
    }

    const bundleName: string | undefined = containerSession?.primarySession?.sceneInfo?.bundleName;
    const oobeBundleName: string = 'com.ohos.hwstartupguide';
    const isForceClean = extraInfo?.isForceClean;
    const exceptionCallback = () => {
      const removeSession = extraInfo?.errorReason === 'appRecovery' ? false : true;
      this.log.showInfo(`errorReason: ${extraInfo?.errorReason}, removeSession ${removeSession}, isforceClean: ${isForceClean}`);
      containerSession.setIsClearSession(removeSession);
      containerSession.requestDestruction(removeSession, false, false, isForceClean);
      destroyFn();
      containerSession.clearTransitionCount();
      if (bundleName === oobeBundleName) {
        this.log.showInfo(`playNormalCloseSceneAnimate primarySession is oobe`);
      }
    }
    if (isException) {
      exceptionCallback();
      return;
    }

    const animationCnt = containerSession.getTransitionCount();
    const scale: number = 0.8;
    const isSystemRTL: boolean = RTLUtil.getSystemRTL();
    this.log.showInfo(`playNormalCloseSceneAnimate animationCnt: ${animationCnt}`);

    const finishCallBack = () => {
      let currentAnimationCnt = containerSession.getTransitionCount();
      this.log.showInfo(`playNormalCloseSceneAnimate onFinish: ${currentAnimationCnt}`);
      performanceMonitor.end('APP_EXIT_FROM_WINDOW_TITLE_BAR_CLOSED');
      if (animationCnt === currentAnimationCnt && containerSession.primarySession?.isClosing) {
        const isClearSession = this.calcIsClearSession(extraInfo);
        this.log.showInfo(`animate finish, isClearSession: ${isClearSession}`);
        containerSession.setIsClearSession(isClearSession);
        containerSession.requestDestruction(true, false, false, isForceClean);
        destroyFn();
        containerSession.clearTransitionCount();
      } else {
        containerSession.primarySession?.setIsClosing(false);
      }
    }
    const animateEvent = () => {
      containerSession.needRenderScale.setScaleXWithDfx(scale, this.tag, 'playNormalCloseSceneAnimate',
        containerSession.getName());
      containerSession.needRenderScale.setScaleYWithDfx(scale, this.tag, 'playNormalCloseSceneAnimate',
        containerSession.getName());
      SCBSceneHelper.setSceneTranslate(containerSession, 0, 0);
      SCBSceneHelper.setSceneScale(containerSession, scale);
      containerSession.primarySession!.opacity = 0;
    }
    // 应用自定义动画
    let customAnimateConfig: sceneSessionManager.TransitionAnimation | undefined =
      containerSession.primarySession?.getTransitionAnimationConfig(sceneSessionManager.WindowTransitionType.DESTROY);
    if (!!customAnimateConfig) {
      this.playCustomCloseSceneAnimate(containerSession, customAnimateConfig, finishCallBack, exceptionCallback);
      return;
    }
    if (extraInfo?.isSplitClose) {
      this.getUiContext()?.animateToImmediately({
        duration: 0,
        onFinish: () => {
          finishCallBack();
        }
      }, () => {
        animateEvent();
      });
    } else {
      animateEvent();
      finishCallBack();
    }
  }

  private playCustomCloseSceneAnimate(containerSession: SCBSceneContainerSession,
    customAnimateConfig: sceneSessionManager.TransitionAnimation,
    finishCallBack: () => void, exceptionCallback: () => void) {
    WinLog.showInfo(WinLogDomain.WMS_ANIMATION, `CustomAnimateConfig curve: ${customAnimateConfig.config.curve}, ` +
      `duration: ${customAnimateConfig.config.duration}, param: ${customAnimateConfig.config.param}, ` +
      `opacity: ${customAnimateConfig.opacity}`)
    let customTimeoutId: number = 0;
    let customFinishCallback = () => {
      finishCallBack();
      clearTimeout(customTimeoutId);
      WinLog.showInfo(WinLogDomain.WMS_ANIMATION, `playCustomCloseSceneAnimate end`);
    }
    let customAnimateParam: AnimateParam =
      WindowAnimationUtils.getInstance().transWindowAnimationOptionsToAnimationParam(
        customAnimateConfig.config, customFinishCallback);
    this.getUiContext()?.animateToImmediately(customAnimateParam, () => {
      if (containerSession.primarySession && !!customAnimateConfig && customAnimateConfig.opacity !== undefined) {
        containerSession.primarySession.opacity = customAnimateConfig.opacity;
      }
    });
    customTimeoutId = setTimeout(() => {
      exceptionCallback();
      WinLog.showInfo(WinLogDomain.WMS_ANIMATION, `playCustomCloseSceneAnimate timeout`);
    }, 3000);
  }

  protected saveAllSceneMemoryInfo(): void {
    if (this.containerSessionList.length === 0) {
      this.log.showInfo('saveAllSceneMemoryInfo containerSessionList is empty');
      return;
    }
    let needSaveContainerSessionArray = new PcSCBSceneContainerSessionArray();
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      needSaveContainerSessionArray.add(this.containerSessionList[i]);
    }
    if (needSaveContainerSessionArray.length === 0) {
      this.log.showInfo('needSaveContainerSession list is empty');
      return;
    }
    for (let i = needSaveContainerSessionArray.length - 1; i >= 0; i--) {
      if (i === 0) {
        this.saveSceneMemoryInfo(needSaveContainerSessionArray[i], true);
      } else {
        this.saveSceneMemoryInfo(needSaveContainerSessionArray[i], false);
      }
    }
    this.log.showInfo(`saveAllSceneMemoryInfo end`);
  }

  protected shouldMinimizeToDock(container: SCBSceneContainerSession): boolean {
    return !this.hasImmersiveWindow(container);
  }

  public saveSceneMemoryInfo(containerSession: SCBSceneContainerSession, isFlush: boolean = true): void {
    if (!containerSession) {
      this.log.showInfo('container session is null, do not save');
      return;
    }
    let primarySession = containerSession.primarySession;
    if (primarySession === null) {
      return;
    }
    let persistentId: ESObject = primarySession.session.persistentId
    let info = primarySession.sceneInfo;
    if (!this.isSaveSceneMemoryInfo(info)) {
      this.log.showInfo(`saveSceneMemoryInfo do not save ${info.bundleName}`);
      return;
    }
    let key = info.bundleName + info.moduleName + info.abilityName;
    let sceneMemoryKey = this.createSceneMemoryKey(info);
    const launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(key);
    let isSingleton = launchType === bundleManager.LaunchType.SINGLETON;
    this.log.showInfo('saveSceneMemoryInfo, launchType ' + launchType);
    let windowMode = info.windowMode;
    if (primarySession.sessionData.isLastSplit) {
      windowMode = SCBSceneMode.PRIMARY;
    }
    this.log.showInfo(`saveSceneMemoryInfo, mode:${windowMode} , ` +
      `currRect:${JSON.stringify(primarySession.currRect)}, lastRect:${JSON.stringify(primarySession.lastRect)}`);
    if ((windowMode === SCBSceneMode.PRIMARY || windowMode === SCBSceneMode.SECONDARY ||
      windowMode === SCBSceneMode.FULLSCREEN) && (primarySession.lastRect.width.getPx() <= 0 ||
      primarySession.lastRect.height.getPx() <= 0)) {
      this.log.showInfo(`saveSceneMemoryInfo do not save ${info.bundleName}`);
      return;
    }
    if (primarySession.currRect.width.getPx() <= 0 || primarySession.currRect.height.getPx() <= 0) {
      this.log.showInfo(`saveSceneMemoryInfo do not save ${info.bundleName}`);
      return;
    }
    let lastDpi: number = this.screenDpiDensity;
    if (windowMode === SCBSceneMode.PRIMARY || windowMode === SCBSceneMode.SECONDARY ||
      windowMode === SCBSceneMode.FULLSCREEN) {
      lastDpi = primarySession.sessionData.lastDpi;
    }
    const context = AppStorage.get<Context>('intentPageContext');
    const store = PreferenceStore.getInstance(context?.getApplicationContext());
    this.deleteSceneMemeryInfo(info);
    let relLayoutFullScreen: boolean = primarySession.getRealLayoutFullScreen();
    if (isSingleton) {
      let memoryInfo: SCBSceneMemoryInfo =
        new SCBSceneMemoryInfo(windowMode, relLayoutFullScreen, info.screenId, lastDpi);
      memoryInfo.setSceneMemoryRect(primarySession.currRect, primarySession.lastRect);
      this.sceneMemoryInfoMap.set(sceneMemoryKey, memoryInfo);
      store.putSync(sceneMemoryKey, memoryInfo as object, isFlush);
      this.log.showInfo(`Singleton session saved in sceneMemoryInfoMap. key: ${key}`);
    } else {
      let haveMultiInstances = this.checkMultiInstances(key, persistentId);
      if (!haveMultiInstances) {
        this.setSpecificWindowNumberMap(info);
        let memoryInfo: SCBSceneMemoryInfo =
          new SCBSceneMemoryInfo(windowMode, relLayoutFullScreen, info.screenId, lastDpi);
        memoryInfo.setSceneMemoryRect(primarySession.currRect, primarySession.lastRect);
        this.sceneMemoryInfoMap.set(sceneMemoryKey, memoryInfo);
        store.putSync(sceneMemoryKey, memoryInfo as object, isFlush);
        this.log.showInfo(`Last MultInstances session saved in sceneMemoryInfoMap. key: ${key}`);
      }
    }
  }

  private setSpecificWindowNumberMap(sceneInfo: SCBSceneInfo) {
    if (!sceneInfo.specifiedFlag) {
      this.log.showWarn(`This session don't have specifiedFlag`);
      return;
    }
    let key: string = sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
    if (!SCBPcScenePanelManager.getInstance().getIsEnableSpecifiedRectAutoSaveMap(key)) {
      this.log.showInfo(`The specifiedFlag is disabled`);
      return;
    }
    let sceneMemeryInfoKey: string = this.createSceneMemoryKey(sceneInfo);
    let saveSpecifiedWindow: undefined | Map<string, number> = this.specificWindowNumberMap.get(key);
    if (saveSpecifiedWindow === undefined) {
      let saveSpecifiedWindowKeyMap: Map<string, number> = new Map();
      saveSpecifiedWindowKeyMap?.set(sceneMemeryInfoKey, 1);
      this.specificWindowNumberMap.set(key, saveSpecifiedWindowKeyMap);
      this.log.showInfo(`new specifiedWindow flag:${sceneInfo.specifiedFlag}`);
      return;
    }
    let specifiedWindowNumber: number = saveSpecifiedWindow?.get(sceneMemeryInfoKey) ?? 0;
    saveSpecifiedWindow?.set(sceneMemeryInfoKey, specifiedWindowNumber + 1);
    this.specificWindowNumberMap.set(key, saveSpecifiedWindow);
    this.log.showInfo(`specific: setSpecificWindowNumberMap key:${sceneMemeryInfoKey}, num:${specifiedWindowNumber +
      1}`)
  }

  private deleteSceneMemeryInfo(sceneInfo: SCBSceneInfo) {
    if (sceneInfo.specifiedFlag === undefined || sceneInfo.specifiedFlag === null) {
      this.log.showInfo(`This session don't have specifiedFlag`);
      return;
    }
    let key: string = sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
    if (!SCBPcScenePanelManager.getInstance().getIsEnableSpecifiedRectAutoSaveMap(key)) {
      this.log.showInfo(`The specifiedFlag is disabled`);
      return;
    }
    let deleteKey: string = this.createSceneMemoryKey(sceneInfo);
    let saveSpecifiedWindow: undefined | Map<string, number> = this.specificWindowNumberMap.get(key);
    if (saveSpecifiedWindow === undefined) {
      return;
    }
    let specifiedWindowNumber: undefined | number = saveSpecifiedWindow.get(deleteKey);
    if (specifiedWindowNumber !== undefined) {
      return;
    }
    if (saveSpecifiedWindow.size + 1 < ViewModelConstant.MAX_NUMBER_RECT_SAVE) {
      return;
    }

    deleteKey = this.getMinimizeSaveWindow(saveSpecifiedWindow) ?? '';
    this.sceneMemoryInfoMap.delete(deleteKey);
    this.specificWindowNumberMap.get(key)?.delete(deleteKey);

    let isWindowRectAutoSaveKey: string = deleteKey?.slice(0, -2);
    SCBPcScenePanelManager.getInstance().setIsWindowRectAutoSaveMap(isWindowRectAutoSaveKey, false);
    SCBSceneSessionManager.getInstance().setIsWindowRectAutoSave(isWindowRectAutoSaveKey, false, key, true);
    this.log.showInfo(`specific: deleteSceneMemeryInfo key:${deleteKey}`)
  }

  private getMinimizeSaveWindow(saveSpecifiedWindow: undefined | Map<string, number>): string | undefined {
    if (saveSpecifiedWindow === undefined) {
      return undefined;
    }
    let minValue = Infinity;
    let minKey: string = '';
    let saveSpecifiedWindowMap: Map<string, number> = saveSpecifiedWindow ?? new Map<string, number>();
    for (const specifiedWindow of saveSpecifiedWindow.entries()) {
      if (specifiedWindow[1] < minValue) {
        minValue = specifiedWindow[1];
        minKey = specifiedWindow[0];
      }
    }
    return minKey;
  }

  private isSaveSceneMemoryInfo(info: SCBSceneInfo): boolean {
    let key: string = SCBPcScenePanelManager.getInstance().createIsWindowRectAutoSaveKey(info);
    this.log.showInfo(`isSaveSceneMemoryInfo ${key}`);
    let isWindowRectAutoSave: boolean | undefined =
      SCBPcScenePanelManager.getInstance().getIsWindowRectAutoSaveMap(key);
    let saveMemoryKey: string = this.createSceneMemoryKey(info);
    let sceneMemoryInfo: SCBSceneMemoryInfo | undefined = this.sceneMemoryInfoMap.get(saveMemoryKey);
    if (isWindowRectAutoSave === undefined) {
      return false;
    }
    if (!isWindowRectAutoSave) {
      if (sceneMemoryInfo !== undefined) {
        this.sceneMemoryInfoMap.delete(saveMemoryKey);
        let abilityKey: string = info.bundleName + info.moduleName + info.abilityName;
        if (SCBPcScenePanelManager.getInstance().getIsEnableSpecifiedRectAutoSaveMap(abilityKey) &&
          info.specifiedFlag !== undefined) {
          this.specificWindowNumberMap.get(abilityKey)?.delete(saveMemoryKey);
          this.log.showInfo(`delete key: ${abilityKey}, createSceneMemoryKey ${saveMemoryKey}`);
        }
      }
      return false;
    }
    return true;
  }

  private preCheckForOnCloseScene(persistentId: number | undefined,
    containerSession: SCBSceneContainerSession | null, isException?: boolean): boolean {
    if (isException && !containerSession && persistentId) {
      const session = this.sessionTempList.getSession(SessionTempListGroupNames.APP_RECOVER, persistentId);
      if (session) {
        this.log.showInfo(`onCloseScene found session Destroy directly`);
        session.requestDestruction(false);
        return false;
      }
    }
    if (!containerSession || !containerSession.primarySession) {
      this.log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return false;
    }
    if (!isException) {
      if (containerSession.primarySession?.isClosing) {
        this.log.showInfo(`isClosing, return`);
        return false;
      } else {
        this.log.showInfo(`Close containerSession with persistentId:${persistentId}`);
        containerSession.primarySession?.setIsClosing(true);
      }
    }
    return true;
  }

  private isRecentState(): boolean {
    return this.isInPanelState(ScenePanelState.RECENT);
  }

  private isSplitState(): boolean {
    return this.isInPanelState(ScenePanelState.SPLIT);
  }

  private isRecentOrSplitState(): boolean {
    return this.isRecentState() || this.isSplitState();
  }

  private checkScenePanelStateWhenCloseScene(containerSession: SCBSceneContainerSession | null,
    persistentId: number | undefined): void {
    if (this.isInPanelState(ScenePanelState.SPLIT) && containerSession?.dividerParam.isSplitRecentPair) {
      this.closeSession = persistentId;
      this.isCloseSplitScreen = true;
      this.exitSplitForPairSplit(persistentId, false);
    }
    if (!this.isInPanelState(ScenePanelState.RECENT)) {
      if (containerSession?.isSplit) {
        this.pcExitSplitCommand = MonitorExitSplitName.CLOSE;
      }
      let param = new ExitSplitParam();
      param.needExitSplitRecent = false;
      if (this.isSplitState()) {
        let curActiveContainerSession = this.getTopActiveSplitSceneContainerSession();
        if (curActiveContainerSession?.primarySession?.sceneInfo.persistentId === persistentId) {
          param.needExitSplitRecent = true;
        }
      }
      param.exitSplitEvent = SCBSessionEventId.EVENT_CLOSE;
      param.needRaise = false;
      this.exitSplitView(persistentId, param);
    }
  }

  private createContainerSession(sceneSession: SCBSceneSession): SCBSceneContainerSession {
    let containerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
    this.addSceneContainerSession(containerSession);
    this.log.showInfo('[SCBMain]start scene add new session: ' + containerSession.containerId);
    return containerSession;
  }

  private createSpecialContainerSession(sceneSession: SCBSceneSession,
    sceneInfo: SCBSceneInfo): SCBSceneContainerSession {
    if (!sceneInfo.isCalledRightlyByCallerId) {
      return this.createContainerSession(sceneSession);
    }
    this.log.showInfo('[SCBMain]create session in the specialContainerSessionList');
    let containerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
    let tempContainerSessionList = new SCBSceneContainerSessionArray();
    tempContainerSessionList.add(containerSession);
    SCBSceneSessionManager.getInstance().onAddSpecialContainerSession(tempContainerSessionList);
    sceneSession.setTemporarilyShowWhenLocked(true);
    return containerSession;
  }

  private startSceneFromOtherCheckSplitState(sceneSession: SCBSceneSession): boolean {
    let isSameSessionInSplit: boolean = false;
    if (this.isInPanelState(ScenePanelState.SPLIT)) {
      let hwContainerSession: SCBSceneContainerSession | null = null;
      for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
        if (this.containerSessionList[i].isSplit && !this.containerSessionList[i].secondarySession) {
          hwContainerSession = this.containerSessionList[i];
          break;
        }
      }
      if (hwContainerSession?.primarySession?.sceneInfo.persistentId) {
        this.exitSplitView(hwContainerSession.primarySession.sceneInfo.persistentId);
        this.log.showInfo('onStartSceneFromOther exit split view.');
        if (hwContainerSession?.primarySession?.sceneInfo.persistentId === sceneSession.session.persistentId) {
          this.log.showInfo('onStartSceneFromOther exit split same persistentId view.');
          isSameSessionInSplit = true;
        }
      }
    }
    return isSameSessionInSplit;
  }

  private startSceneByCallInner(isFirstCall: boolean, toInfo: SCBSceneInfo,
    toContainerSession: SCBSceneContainerSession, toSceneSession: SCBSceneSession,
    topActiveSceneSession: SCBSceneContainerSession | null): void {
    this.log.showInfo(`onSceneStartByCall isFirstCall:${isFirstCall} toInfo.callState:${toInfo.callState} ` +
      `scenePanelState ${this.getScenePanelState()}`);
    if (isFirstCall && toInfo.callState === CallToState.FOREGROUND) {
      this.addSceneContainerSession(toContainerSession);
      this.sendAndSetRecentDataList(toContainerSession);
      toContainerSession.requestActivationByCall(true);
      this.raiseSceneToTop(toContainerSession);
      this.enterFullSceneOrHomeView(ScenePanelState.HOME)
      toSceneSession.sessionData.isNewWant = true;
      if (topActiveSceneSession != null &&
      this.needMinimizeActiveContainer(toContainerSession, topActiveSceneSession)) {
        this.log.showInfo('topActiveSceneSession requestBackground');
        topActiveSceneSession.requestBackground();
      }
    } else if (isFirstCall && toInfo.callState === CallToState.BACKGROUND) {
      this.addSceneContainerSessionNotShowRecent(toContainerSession);
      toContainerSession.requestActivationByCall(false);
      toSceneSession.sessionData.isNewWant = true;
    } else if (!isFirstCall && toInfo.callState == CallToState.FOREGROUND) {
      this.removeSceneContainerSessionNotShowRecent(toContainerSession);
      this.addSceneContainerSession(toContainerSession);
      this.sendAndSetRecentDataList(toContainerSession);
      toContainerSession.requestActivationByCall(true);
      this.raiseSceneToTop(toContainerSession);
      this.enterFullSceneOrHomeView(ScenePanelState.HOME);
      if (topActiveSceneSession != null &&
      this.needMinimizeActiveContainer(toContainerSession, topActiveSceneSession)) {
        this.log.showInfo('topActiveSceneSession requestBackground');
        topActiveSceneSession.requestBackground();
      }
    } else if (!isFirstCall && toInfo.callState === CallToState.BACKGROUND) {
      toContainerSession.requestActivationByCall(false);
      toSceneSession.sessionData.isNewWant = true;
    } else {
      this.log.showInfo('error callState');
    }
  }

  private startSceneByCallFromRoot(toInfo: SCBSceneInfo): void {
    this.log.showInfo('[SCBMain]onRootSceneStartByCall with sceneInfo:{persistentId: %{public}d, ' +
      'bundleName:%{public}s, moduleName:%{public}s, abilityName:%{public}s}',
      toInfo.persistentId, toInfo.bundleName, toInfo.moduleName, toInfo.abilityName);
    let toSceneSession = this.requestSceneSession(toInfo);
    if (toSceneSession == null) {
      this.log.showError('[SCBMain]Failed to get toSceneSession: ' + toInfo?.getName());
      return;
    }
    let isFirstCall = false;
    let toContainerSession = this.getSceneContainerSessionWithPersistentId(toSceneSession.session.persistentId);
    if (toContainerSession === null) {
      toContainerSession = new SCBSceneContainerSession(toSceneSession, this.screenProperty);
      isFirstCall = true;
    }
    this.log.showInfo(`onRootSceneStartByCall isFirstCall:${isFirstCall} toInfo.callState:${toInfo.callState} ` +
      `scenePanelState ${this.getScenePanelState()}`);
    if (isFirstCall && toInfo.callState === CallToState.FOREGROUND) {
      this.addSceneContainerSession(toContainerSession);
      this.sendAndSetRecentDataList(toContainerSession);
      toContainerSession.requestActivationByCall(true);
      this.raiseSceneToTop(toContainerSession);
      this.enterFullSceneOrHomeView(ScenePanelState.HOME);
      toSceneSession.sessionData.isNewWant = true;
    } else if (isFirstCall && toInfo.callState == CallToState.BACKGROUND) {
      this.addSceneContainerSessionNotShowRecent(toContainerSession);
      toContainerSession.requestActivationByCall(false);
      toSceneSession.sessionData.isNewWant = true;
    } else if (!isFirstCall && toInfo.callState === CallToState.FOREGROUND) {
      this.removeSceneContainerSessionNotShowRecent(toContainerSession);
      this.addSceneContainerSession(toContainerSession);
      this.sendAndSetRecentDataList(toContainerSession);
      toContainerSession.requestActivationByCall(true);
      this.raiseSceneToTop(toContainerSession);
      this.enterFullSceneOrHomeView(ScenePanelState.HOME);
    } else if (!isFirstCall && toInfo.callState === CallToState.BACKGROUND) {
      toContainerSession.requestActivationByCall(false);
      toSceneSession.sessionData.isNewWant = true;
    } else {
      this.log.showInfo('error callState');
    }
  }

  private setPointerDelayTimer(): void {
    this.pointerDelayTimer = setTimeout(() => {
      let desktopId = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_DESKTOP,
          this.screenProperty.screenId)?.id;
      this.log.showInfo('[SCBMain]onPreStartSpecified setPointerDelayTimer desktopId=' + desktopId);
      if (desktopId != undefined) {
        pointer.setPointerStyle(desktopId, pointer.PointerStyle.RUNNING);
      }
      this.pointerDelayTimer = null;
    }, 350)
  }

  private setClearPointerDelayTimer(): void {
    this.clearPointerDelayTimer = setTimeout(() => {
      let desktopId = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_DESKTOP,
          this.screenProperty.screenId)?.id;
      this.log.showInfo('[SCBMain]onPreStartSpecified setClearPointerDelayTimer desktopId=' + desktopId);
      if (desktopId !== undefined) {
        pointer.setPointerStyle(desktopId, pointer.PointerStyle.DEFAULT);
      }
      clearTimeout(this.pointerDelayTimer);
      this.clearPointerDelayTimer = null;
    }, 1600)
  }

  private setSceneSessionOpacity(toContainerSession: SCBSceneContainerSession): void {
    this.log.showInfo('[SCBMain]setSceneSessionOpacity, sessionName: ' + toContainerSession.getName());
    SCBSceneHelper.setSceneTranslate(toContainerSession, 0, 0);
    SCBSceneHelper.setSceneScale(toContainerSession, 1);
    SCBSceneHelper.setSceneOpacity(toContainerSession, 1);
  }

  private sceneSessionToSpecialSceneSession(containerSession: SCBSceneContainerSession | null,
    isCalledRightlyByCallerId: boolean,
    isShowAboveKeyguard: boolean): void {
    if (!isCalledRightlyByCallerId) {
      this.log.showWarn('[SCBMain]check fromInfo token failed!');
      return;
    }
    if (isShowAboveKeyguard && containerSession !== null) {
      this.log.showInfo('[SCBMain]containerSession from containerSessionList to specialContainerSessionList');
      this.removeSceneContainerSession(containerSession);
      let tempContainerSessionList = new SCBSceneContainerSessionArray();
      tempContainerSessionList.add(containerSession);
      SCBSceneSessionManager.getInstance().onAddSpecialContainerSession(tempContainerSessionList);
      containerSession.primarySession?.setTemporarilyShowWhenLocked(true);
    }
  }

  private calculateMaxRect(sceneSession: SCBSceneSession): SCBSessionRect {
    const layoutFullScreen = sceneSession.layoutFullScreen || sceneSession.sessionData.isMaximizeFullScreen;
    const screenId = this.screenProperty.screenId;
    let isDockAutoHide = AppStorage.get<boolean>('isDockAutoHide');
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    let dockHeight = 0;
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    if (dock && !isDockAutoHide) {
      dockHeight = dock.currRect.height.getPx();
    }
    const statusBarHeight = isDockAutoHide ? 0 : SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenId);
    let posY = layoutFullScreen ? 0 : statusBarHeight;
    let width = this.screenProperty.width;
    let height = this.screenProperty.height;
    // If it is not immersive, a black status bar is displayed.
    if (!layoutFullScreen) {
      height = this.screenProperty.height - dockHeight - statusBarHeight;
      SCBSceneSessionManager.getInstance().fullScreenLayoutChange(true, this.screenProperty.screenId);
      viewMgrPolicy.hideView(ViewType.GESTURE_TOP_BAR + this.screenProperty.screenId * SCREEN_INDEX);
      multiInputManager.recoverMouseEvent();
    } else {
      statusBar?.setFocusable(false);
      if (statusBar !== null) {
        viewMgrPolicy.setZIndex(
          ViewType.GESTURE_TOP_BAR + this.screenProperty.screenId * SCREEN_INDEX, statusBar.zIndex - 1);
      }
      viewMgrPolicy.showView(ViewType.GESTURE_TOP_BAR + this.screenProperty.screenId * SCREEN_INDEX);
    }
    return new SCBSessionRect(0, posY, width, height);
  }

  private getContainerWithPersistentIdOrContainerId(persistentId?: number,
    containerId?: number): SCBSceneContainerSession | null {
    if (persistentId) {
      return this.getSceneContainerSessionWithPersistentId(persistentId);
    }
    return this.getSceneContainerSessionWithContainerId(containerId);
  }

  private needMinimizeActiveContainer(currContainer: SCBSceneContainerSession | null,
    activeSceneContainerSession: SCBSceneContainerSession | null): boolean {
    if (!activeSceneContainerSession || !currContainer) {
      return false;
    }
    if (currContainer.containerId === activeSceneContainerSession.containerId) {
      return false;
    }
    // need to consider split
    const windowMode = currContainer.getContainerWindowMode();
    const activeContainerMode = activeSceneContainerSession.getContainerWindowMode();
    if (windowMode === SCBSceneMode.FULLSCREEN && activeContainerMode === SCBSceneMode.FULLSCREEN) {
      return true;
    }
    return false;
  }

  private getTopActiveSplitSceneContainerSession(): SCBSceneContainerSession | null {
    if (this.containerSessionList.length === 0) {
      this.log.showError('getTopActiveSplitSceneContainerSession ' +
        'Failed to find active scene container session with list length 0.');
      return null;
    }
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      const containerSession = this.containerSessionList[i];
      if (containerSession.isActive && containerSession.isOneStepSplit()) {
        return this.containerSessionList[i];
      }
    }
    this.log.showError('no active split session');
    return null;
  }

  private addSceneContainerSessionNotShowRecent(container: SCBSceneContainerSession): void {
    if (!container) {
      return;
    }
    const index = this.containerSessionListNotShowRecent.findIndex(item => {
      return item.containerId === container.containerId;
    });
    if (index === -1) {
      this.log.showInfo('Add scene container session in not show list, id: ' + container.containerId);
      this.containerSessionListNotShowRecent.push(container);
    }
  }

  private removeSceneContainerSessionNotShowRecent(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    const index = this.containerSessionListNotShowRecent.findIndex((item) => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index !== -1) {
      this.log.showInfo('Remove scene container session in not show list, id: ' + sceneContainerSession.containerId);
      this.containerSessionListNotShowRecent.splice(index, 1);
    }
  }

  private isNeedAddToContainerListAndRemoveFromNotShowList(persistentId: number,
    sceneContainerSession: SCBSceneContainerSession | null): boolean {
    if (persistentId === undefined || sceneContainerSession === null) {
      return false;
    }

    let index1 = this.containerSessionList.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });

    let index2 = this.containerSessionListNotShowRecent.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });

    if (index1 === -1 && index2 !== -1) {
      this.removeSceneContainerSessionNotShowRecent(sceneContainerSession);
      this.log.showInfo(`remove from containerSessionListNotShowRecent.`);
      return true;
    }
    return false;
  }

  private raiseSceneToTop(sceneContainerSession: SCBSceneContainerSession) {
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, 'raiseSceneToTop.');
    sceneContainerSession.updateLastUsedTimestamp(Date.now());
    // To move the sceneContainerSession to the last of list.
    this.removeSceneContainerSession(sceneContainerSession);
    this.addSceneContainerSession(sceneContainerSession);

    this.panelProxy.refreshRecentInfo();
  }

  // raise scene to top, to solve the performance issue, make operation cause time async
  private raiseSceneToTopAsync(sceneContainerSession: SCBSceneContainerSession, persistentId: number) {
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, 'raiseSceneToTopAsync inner start');
    // To move the sceneContainerSession to the last of list.
    this.moveSceneContainerSessionToLastAndRequestFocus(sceneContainerSession, persistentId);

    // timeout for 0ms to ensure ui first
    setTimeout(() => {
      this.panelProxy.refreshRecentInfo();
    }, 0);
  }

  /**
   * 抬升窗口层级
   *
   * @param sceneContainerSession
   * @param persistentId 分屏场景才需要传该参数，其他场景可不传
   */
  private raisePresentSceneToTop(sceneContainerSession: SCBSceneContainerSession,
    persistentId?: number, reason?: SCBWindowRaiseReason) {
    if (!sceneContainerSession) {
      this.log.showError('session is nullptr');
      return;
    }
    const index = this.containerSessionList.findIndex((item) => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (index === -1 || this.isTopContainerSession(sceneContainerSession, index)) {
      if (sceneContainerSession.isSplit && sceneContainerSession.secondarySession) {
        sceneContainerSession.dividerParam.isFocusPrimary =
          sceneContainerSession.primarySession?.sceneInfo.persistentId === persistentId;
        const isPrimaryRaise = sceneContainerSession.primarySession?.sceneInfo.persistentId === persistentId;
        sceneContainerSession.dividerParam.isPrimaryRaise = isPrimaryRaise;
        this.log.showInfo(`raisePresentSceneToTop sceneContainerSession id:${sceneContainerSession.containerId}
                isPrimaryRaise:${isPrimaryRaise}`);
        // 刷新一下 zIndex
        sceneContainerSession.dividerParam.setPrimaryZIndex(isPrimaryRaise ? 0 : -1);
        sceneContainerSession.dividerParam.setSecondaryZIndex(isPrimaryRaise ? -1 : 0);
        this.refreshZOrder();
      }
      return;
    }
    this.raiseSceneToTop(sceneContainerSession);
  }

  private isTopContainerSession(sceneContainerSession: SCBSceneContainerSession, index: number): boolean {
    if (index !== this.containerSessionList.length - 1) {
      return false;
    }
    const allContainerIndex = SCBSessionListManager.allContainerSessionList.findIndex((item) => {
      return item.containerId === sceneContainerSession.containerId;
    });
    return allContainerIndex === SCBSessionListManager.allContainerSessionList.length - 1;
  }

  // move SceneContainerSession to last of the array, same as remove then add
  private moveSceneContainerSessionToLastAndRequestFocus(sceneContainerSession: SCBSceneContainerSession,
    persistentId: number) {
    if (!sceneContainerSession) {
      return;
    }
    this.removeSceneContainerSessionNotShowRecent(sceneContainerSession);

    const indexRemove = this.containerSessionList.findIndex((item) => {
      return item.containerId === sceneContainerSession.containerId;
    });
    if (indexRemove != -1) {
      this.log.showInfo('Remove scene container session, id: ' + sceneContainerSession.containerId);
      this.containerSessionList.splice(indexRemove, 1);

      // timeout for 0ms to ensure ui first
      // to do: move this to native to increase performance
      setTimeout(() => {
        let isPrimaryRaise = false;
        if (sceneContainerSession.isSplit && sceneContainerSession.secondarySession &&
          sceneContainerSession.primarySession?.sceneInfo.persistentId === persistentId) {
          sceneContainerSession.dividerParam.isFocusPrimary = true;
          isPrimaryRaise = true;
        }
        if (sceneContainerSession.isSplit && sceneContainerSession.primarySession &&
          sceneContainerSession.secondarySession?.sceneInfo.persistentId === persistentId) {
          sceneContainerSession.dividerParam.isFocusPrimary = false;
          isPrimaryRaise = false;
        }
        sceneContainerSession.dividerParam.isPrimaryRaise = isPrimaryRaise;
        // 刷新一下 zIndex
        sceneContainerSession.dividerParam.setPrimaryZIndex(isPrimaryRaise ? 0 : -1);
        sceneContainerSession.dividerParam.setSecondaryZIndex(isPrimaryRaise ? -1 : 0);
        this.refreshZOrder();
        SCBSceneSessionManager.getInstance().requestFocus(persistentId, true, FocusChangeReason.MOVE_UP);
        const primaryZorder = sceneContainerSession.primarySession?.sessionInfo.zOrder;
        const secondaryZorder = sceneContainerSession.secondarySession?.sessionInfo.zOrder;
        this.log.showDebug(`moveSceneContainerSessionToLastAndRequestFocus ` +
          `primaryZorder:${primaryZorder}, secondaryZorder:${secondaryZorder}`);
      }, 0);
    }

    this.addSceneContainerSession(sceneContainerSession);
  }

  private enterFullSceneOrHomeView(state: ScenePanelState): void {
    this.containerSessionList.forEach((containerSession) => {
      if (containerSession.isActive) {
        containerSession.init();
      }
    });
    this.panelProxy.updateScenePanelState(state);
  }

  private enterFullSceneOrHomeViewWithSession(state: ScenePanelState, container: SCBSceneContainerSession): void {
    container.init();
    this.panelProxy.updateScenePanelState(state);
  }

  private applyStartScene(sceneInfo: SCBSceneInfo, sceneSession: SCBSceneSession): void {
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
    if (sceneContainerSession?.primarySession?.isClosing) {
      this.log.showWarn(`The sceneContainerSession: ${sceneContainerSession.containerId} is closing`);
      return;
    }
    if (this.isInPanelState(ScenePanelState.RECENT)) {
      if (sceneContainerSession !== null) {
        this.log.showInfo('onStartSceneFromIcon Start recent scene:' + sceneContainerSession.containerId);
        this.startSceneFromRecent(sceneSession.session.persistentId, sceneContainerSession.containerId);
        return;
      }
      this.exitRecentView();
    }

    let isNeedSetRecentDataList: boolean = false;
    const coldStart: boolean = this.isSceneColdStart(sceneSession);
    if (sceneContainerSession === null) {
      sceneContainerSession = new SCBSceneContainerSession(sceneSession, this.screenProperty);
      isNeedSetRecentDataList = true;
      this.log.showInfo('start scene add new session: ' + sceneContainerSession.containerId);
    } else if (this.isNeedAddToContainerListAndRemoveFromNotShowList(sceneSession.session.persistentId,
      sceneContainerSession)) {
      isNeedSetRecentDataList = true;
    }
    sceneSession.sessionData.sceneSessionEverShown = true;
    this.resizeWhenStartSceneIfNeed(sceneContainerSession);
    this.raiseSceneToTop(sceneContainerSession);
    const oldIsActive = sceneContainerSession.isActive;
    const visibility: boolean = sceneContainerSession.needRenderVisibility.visibility;
    this.log.showInfo(`applyStartScene isSceneActive: ${sceneContainerSession.primarySession?.isActive}, ` +
      `visibility: ${visibility}`);
    this.isNewWant = sceneSession.isNewWant;
    sceneContainerSession.requestActivation(sceneSession.isNewWant);
    sceneContainerSession.needRenderVisibility.setVisibilityWithDfx(true, this.tag, 'initVisibility',
      sceneContainerSession.getName());
    sceneSession.sessionData.isNewWant = true;
    if (!oldIsActive || !visibility) {
      const transitionsContext = this.getTransitionsContext(sceneInfo);
      const transitionController = SCBTransitionManager.getInstance().findTransitionController(transitionsContext[0],
        () => {
          const appData = PageDesktopModel.getInstance().getCloseAppData(transitionsContext[0],
            transitionsContext[1], null, null, this.getExtraId(), sceneInfo.appIndex, null, sceneInfo?.appInstanceKey);
          appData.screenId = this.screenProperty.screenId;
          return appData;
        });
      this.log.showInfo(`start scene controller: ${transitionController?.appData.bundleName}`);
      sceneContainerSession.initCompanionIconInfo(sceneInfo, transitionController);
      performanceMonitor.begin(PageDesktopModel.getInstance().getSceneLaunchType(
        sceneContainerSession.companionIconInfo), performanceMonitor.ActionType.LAST_UP, sceneInfo.bundleName);
      this.onSceneContainerTransitionIn(sceneContainerSession, transitionController,
        sceneInfo.want.parameters?.startParams, isNeedSetRecentDataList, coldStart);
    } else {
      if (isNeedSetRecentDataList) {
        this.sendAndSetRecentDataList(sceneContainerSession, false);
      }
    }
    this.refreshZOrder();
  }

  private getAppInfoFromDock(sceneContainerSession: SCBSceneContainerSession,
    extraInfo?: ExecuteCallbackExtraInfo): AppItemInfo {
    let bundleName = sceneContainerSession.primarySession?.sceneInfo.bundleName ?? '';
    let abilityName = sceneContainerSession.primarySession?.sceneInfo.abilityName ?? '';
    let persistentId = sceneContainerSession.primarySession?.sceneInfo.persistentId;
    const isRecycleBin = this.panelProxy.isRecycleBin(sceneContainerSession.primarySession?.sceneInfo, extraInfo);
    const isIndependentIconAbility =
      PcDockIndepentIconMgr.getInstance().isIndependentIconAbility(bundleName, String(persistentId));
    this.log.showInfo(`getAppInfoFromDock isRecycleBin: ${isRecycleBin}`);
    if (isRecycleBin) {
      bundleName = CommonConstants.LAUNCHER_BUNDLE;
      abilityName = CommonConstants.RECYCLE_BIN_ABILITY;
    }
    // fileManager use files dockItem
    if (bundleName === CommonConstants.FILE_MANAGER_BUNDLE && PCDockUtils.isFilesBundleExist()) {
      bundleName = CommonConstants.PHONE_FILE_MANAGER_BUNDLE;
    }
    let dockItemInfo: DockItemInfo = {
      bundleName: bundleName,
      abilityName: abilityName,
      appIndex: sceneContainerSession.primarySession?.sceneInfo.appIndex ?? 0,
      appInstanceKey: sceneContainerSession.primarySession?.sceneInfo.appInstanceKey ?? '',
      visible: false,
      borderVisible: false,
      shake: 0,
      missionInfoList: [],
      appIconId: 0,
      appName: '',
    }
    if (isIndependentIconAbility) {
      dockItemInfo.persistentId = String(persistentId);
    }
    let appItem = PageDesktopModel.getInstance().getAppInfoFromDock(dockItemInfo);
    if (!appItem) {
      this.log.showInfo('getAppInfoFromDock appItem is undefined');
      let collaborationDataList: DockItemInfo[] | undefined = AppStorage.get('collaborationDataList');
      if (!CheckEmptyUtils.isEmptyArr(collaborationDataList)) {
        let collaDockItem = collaborationDataList?.find((item: DockItemInfo) => {
          return item?.bundleName === bundleName;
        });
        if (collaDockItem) {
          return collaDockItem as AppItemInfo;
        }
      }

      let resistDockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let dockItem = resistDockItems.find((item: DockItemInfo) => {
        return item?.bundleName === bundleName;
      });
      if (dockItem) {
        return dockItem as AppItemInfo;
      }
      let recentItems: RecentBundleMissionInfo[] =
        AppStorage.get<RecentBundleMissionInfo[]>('recentList') as DockItemInfo[];
      let recentItem = recentItems?.find((item: RecentBundleMissionInfo) => {
        return item?.bundleName === bundleName;
      });
      return recentItem as AppItemInfo;
    }
    return appItem;
  }

  private getAppItemKey(controller: SCBTransitionController): string {
    const appData = controller?.appData;
    if (!appData) {
      return '';
    }
    // 获取图标keyName, 与PcDockAnimationMgr中获取keyName的方法保持一致
    const key = appData.bundleName + '_' + appData.appIndex + '_' + appData.abilityName + '_' +
      COMMON_ICON_TYPE + '_' + (appData.persistentId ?? '') + '_' + (appData.appInstanceKey ?? '');
    return key;
  }

  private onSceneContainerTransitionIn(sceneContainerSession: SCBSceneContainerSession,
    controller: SCBTransitionController, startParams?: Object,
    isNeedSetRecentDataList: boolean = false, coldStart: boolean = false, extraInfo?: ExecuteCallbackExtraInfo): void {
    this.log.showInfo(`[SCBMain]onSceneContainerTransitionIn name: ${sceneContainerSession.getName()}`);
    HiSysEventUtil.reportStartApp(controller?.appData?.bundleName);
    AnimateToScheduleUtils.reportStartAppToRss(controller?.appData?.bundleName);
    TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP);
    this.log.showInfo(`${TraceUtil.CORE_METHOD_START_APP}:${controller?.appData?.bundleName}`);
    sceneContainerSession.needRenderScale.setScaleXWithDfx(1.0, this.tag, 'onSceneContainerTransitionIn',
      sceneContainerSession.getName());
    sceneContainerSession.needRenderScale.setScaleYWithDfx(1.0, this.tag, 'onSceneContainerTransitionIn',
      sceneContainerSession.getName());
    sceneContainerSession.needRenderTranslate.setTranslateYWithDfx(0, this.tag, 'onSceneContainerTransitionIn',
      sceneContainerSession.getName());
    sceneContainerSession.needRenderTranslate.setTranslateXWithDfx(0, this.tag, 'onSceneContainerTransitionIn',
      sceneContainerSession.getName());
    SCBSceneHelper.setSceneTranslate(sceneContainerSession, 0, 0);
    SCBSceneHelper.setSceneScale(sceneContainerSession, 1);
    if (sceneContainerSession.isSplit && sceneContainerSession.secondarySession) {
      this.setSpecificSceneOpacity(sceneContainerSession, 1);
      this.resetSpecificSceneTransition(sceneContainerSession);
      sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, this.tag,
        'onSceneContainerTransitionInNoAni', sceneContainerSession.getName());
      this.exitSplitIfControl(sceneContainerSession);
      return;
    }
    let primarySession = sceneContainerSession.primarySession;
    if (!primarySession) {
      this.log.showError('onSceneContainerTransitionIn sceneContainerSession.primarySession is null');
      return;
    }

    if (primarySession.isMinimizing) {
      primarySession.isMinimizing = false;
    }

    // app icon transition in animation (position, scale, opcity)
    let iconRect: RectInfo = new RectInfo();
    const context: UIContext = this.getUiContext();
    let appItem = this.getAppInfoFromDock(sceneContainerSession, extraInfo);
    if (!startParams) {
      if (appItem) {
        iconRect = this.getIconRect(appItem);
        this.isHide = this.isHideOnDock(appItem);
      }
    } else {
      if (startParams instanceof Map) {
        let params = startParams as Map<string, Object>;
        let itemRect = params.get(KeyConstants.ITEM_RECT);
        if (itemRect !== undefined) {
          iconRect = itemRect as RectInfo;
        }
      }
      this.log.showInfo(`get iconRect from request, rect:` +
        `{left:${iconRect.left},top:${iconRect.top},right:${iconRect.right},bottom:${iconRect.bottom}}`);
    }
    if (this.isNewWant) {
      const bundleName =
        controller?.appData?.bundleName ? controller?.appData?.bundleName : primarySession.sceneInfo.bundleName;
      const abilityName =
        controller?.appData?.abilityName ? controller?.appData?.abilityName : primarySession.sceneInfo.abilityName;
      const appIndex =
        controller?.appData?.appIndex ? controller?.appData?.appIndex : primarySession.sceneInfo.appIndex;
      const appInstanceKey = primarySession.sceneInfo?.appInstanceKey;
      let key = SMARTDOCK_APPICON_CONTAINER + `${bundleName}_${abilityName}_${appIndex}_${appInstanceKey}`;
      if (!CheckEmptyUtils.isEmpty(controller?.appData?.shortcutId)) {
        key = key + `_${controller?.appData?.shortcutId}`;
      }
      let iconRectTemp = ItemUtils.getRectById(key);
      if (iconRectTemp && iconRectTemp.left !== 0 && iconRectTemp.right !== 0) {
        iconRect = iconRectTemp;
      }
      this.isNewWant = false;
    }
    const iconWidth = iconRect.right - iconRect.left;
    const iconHeight = iconRect.bottom - iconRect.top;
    const hasIcon: boolean = ((iconWidth !== 0) && (iconHeight !== 0));
    let newRect = primarySession.currRect.copy();
    const sceneWidth = SCBSystemSceneUtils.getInstance().px2vp(context, newRect.width.getPx());
    const sceneHeight = SCBSystemSceneUtils.getInstance().px2vp(context, newRect.height.getPx());
    const sceneTransX = SCBSystemSceneUtils.getInstance().px2vp(context, newRect.left.getPx());
    const sceneTransY = SCBSystemSceneUtils.getInstance().px2vp(context, newRect.top.getPx());
    const sceneCenterPosX = sceneTransX + sceneWidth / 2;
    const sceneCenterPosY = sceneTransY + sceneHeight / 2;
    const isNonTraceable: boolean = coldStart || controller?.appData?.startAppType === StartType.APP_CENTER_APP;
    const canDoAttractionAnim = this.canDoAttractionAnim();
    const doAttractionAnim: boolean = !isNonTraceable && canDoAttractionAnim;
    this.log.showInfo(`icon rect:${iconRect.toString()} sceneWidth:${sceneWidth}, sceneHeight:${sceneHeight}`);
    if ((sceneHeight === 0) || (sceneWidth === 0)) {
      this.log.showInfo(`primarySession width or height is invailed: sceneWidth:${sceneWidth}, sceneHeight:${sceneHeight}`);
      return;
    }
    if (!coldStart) {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MIN_RECOVER, StyleConstants.DEFAULT_1);
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.RECOVER_MIN_WINDOW, !doAttractionAnim);
    }
    const dockHeight = SCBSystemSceneUtils.getInstance().getDockHeightVP(this.uiContext, this.screenProperty.screenId);
    const iconTransX = (iconRect.left + iconWidth / 2);
    const iconTransY = SCBSystemSceneUtils.getInstance().px2vp(this.uiContext, this.screenProperty.height) - dockHeight;
    const centerTranX = sceneCenterPosX - iconTransX;
    const centerTranY = sceneCenterPosY - (iconRect.top + iconHeight / 2);
    const iconTransAlpha = (controller?.appData?.startAppType === StartType.CARD) ?
    this.CARD_ICON_TRANS_ALPHA : this.APP_ICON_TRANS_ALPHA;
    const itemWidth = this.panelProxy.getCardWidth() + FixedDockResource.SNAPSHOT_GAP;
    const itemHeight = FixedDockResource.SNAPSHOT_ITEM_HEIGHT;
    const cardHeight = FixedDockResource.SNAPSHOT_IMAGE_HEIGHT;

    let sceneScaleX = iconWidth / sceneWidth;
    let sceneScaleY = iconHeight / sceneHeight;
    let sceneInitTranX = hasIcon ? -centerTranX :
      (SCBSystemSceneUtils.getInstance().px2vp(context, this.screenProperty.width) * 0.5 - sceneCenterPosX);
    let sceneInitTranY = hasIcon ? -centerTranY :
      (SCBSystemSceneUtils.getInstance().px2vp(context, this.screenProperty.height) * 0.75 - sceneCenterPosY);
    if (this.panelProxy.isOpenFromPopup()) {
      sceneInitTranX = this.panelProxy.getCardPositionX() + (itemWidth / 2) - sceneCenterPosX;
      sceneInitTranY = this.panelProxy.getCardPositionY() + (itemHeight / 2) - sceneCenterPosY;
      sceneScaleX = this.panelProxy.getCardWidth() / sceneWidth;
      sceneScaleY = cardHeight / sceneHeight;
    }

    if (doAttractionAnim) {
      primarySession.setScale(1.0, 1.0);
      primarySession.setTran(0, 0);
      primarySession.attractionTransX = iconTransX - sceneTransX;
      primarySession.attractionTransY = iconTransY - sceneTransY;
      primarySession.attractionTransY -= this.fixAttractionTranslate();
      primarySession.attractionVal = 1;
      primarySession.opacity = 1;
    } else {
      primarySession.setScale(sceneScaleX, sceneScaleY);
      if (!isNonTraceable) {
        primarySession.floatBorderRadius = CommonConstants.DEFAULT_ICON_RADIUS;
      }
      primarySession.setTran(sceneInitTranX, sceneInitTranY);
      primarySession.opacity = this.panelProxy.isOpenFromPopup() ? 1.0 : 0.0;
      primarySession.attractionVal = 0;
      primarySession.blurRadius = 0;
    }
    const sceneRadius = primarySession.floatBorderRadius * (this.screenDpiDensity / ViewModelConstant.BASE_DENSITY);

    this.log.showInfo(`scene dst state[attraction:${doAttractionAnim}, scale:${primarySession.scaleX}, ` +
      `opacity:${primarySession.opacity}, tranX:${primarySession.translateX}, tranY:${primarySession.translateY}, ` +
      `isOpenFromPopup:${this.panelProxy.isOpenFromPopup()}, startAppType:${controller?.appData?.startAppType}, ` +
      `isAttractionEnabled:${canDoAttractionAnim}]`);

    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    this.log.showInfo(`${TraceUtil.CORE_METHOD_START_APP_ANI}:start`);
    this.isHide = false;
    sceneContainerSession.addTransitionCount();
    if (isNeedSetRecentDataList) {
      this.sendAndSetRecentDataList(sceneContainerSession, false);
    }
    controller?.onInactive?.(this.tag, 'onSceneContainerTransitionIn');
    this.onStartSceneAnimation(sceneContainerSession, primarySession, hasIcon, doAttractionAnim, isNonTraceable,
      coldStart, extraInfo);
    this.updateSubSessionWhenRelativeToParent(primarySession);
    if (this.panelProxy.isOpenFromPopup()) {
      AppStorage.set('isOpenFromPopup', false)
    }
    this.log.showInfo('scene dst state[scale:' + primarySession.scaleX + ', opacity:' +
    primarySession.opacity + ', tranX:' + primarySession.translateX + ', tranY:' + primarySession.translateY + ']');
  }

  private onStartSceneAnimation(sceneContainerSession: SCBSceneContainerSession,
    primarySession: SCBSceneSession, hasIcon: boolean, doAttractionAnim: boolean,
    isNonTraceable: boolean, coldStart: boolean, extraInfo?: ExecuteCallbackExtraInfo): void {
    const animationCnt: number = sceneContainerSession.getTransitionCount();
    this.log.showInfo(`onSceneContainerTransitionIn animationCnt: ${animationCnt}`);
    const type: string = PageDesktopModel.getInstance().getSceneLaunchType(sceneContainerSession.companionIconInfo);
    const sceneInfo = primarySession.sceneInfo;
    const transitionsContext = this.getTransitionsContextForIconAnimate(sceneInfo, extraInfo);
    const transitionController = SCBTransitionManager.getInstance().findTransitionController(transitionsContext[0],
      () => {
        const appData = PageDesktopModel.getInstance().getCloseAppData(transitionsContext[0],
          transitionsContext[1], StartType.DOCK_APP, null, null, sceneInfo.appIndex, null);
        appData.screenId = this.screenProperty.screenId;
        return appData;
      });
    const finishCallback = () => {
      TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      this.log.showInfo(`${TraceUtil.CORE_METHOD_START_APP_ANI}:end`);
      performanceMonitor.end(type);
      CloseAppManager.getInstance().resetStartAppSubtype();
      CloseAppManager.getInstance().setStartAppType(StartType.APP);
      let currentAnimationCnt = sceneContainerSession.getTransitionCount();
      this.log.showInfo(`onSceneContainerTransitionIn onFinish: ${currentAnimationCnt}`);
      if (animationCnt === currentAnimationCnt) {
        if (doAttractionAnim && !isNonTraceable) {
          primarySession.resetOcclusionAlpha();
          primarySession.isAttracting = false;
          primarySession.setSidebarBlur(true, true);
        }
        this.log.showInfo('raiseAnimateToSchedulePriority:start app end');
        AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
        sceneContainerSession.clearTransitionCount();
      }
      if (!coldStart) {
        // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MIN_RECOVER, StyleConstants.DEFAULT_0);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.RECOVER_MIN_WINDOW);
      }
    };
    const delayAnimateMs = hasIcon ? 135 : 0;
    const sceneWidth = primarySession.currRect.width.getVp();
    const sceneHeight = primarySession.currRect.height.getVp();
    this.doSpecificSceneAnimateIn(primarySession, delayAnimateMs);
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, this.tag, 'onSceneContainerTransitionIn',
      sceneContainerSession.getName());
    if (doAttractionAnim) {
      primarySession.setOcclusionAlpha(0);
      primarySession.isAttracting = true;
      this.getUiContext()?.animateTo({
        duration: 0,
        onFinish: finishCallback
      }, () => {
        primarySession.attractionVal = 0;
      })
      this.getUiContext()?.animateTo({
        duration: 0,
      }, () => {
        transitionController?.onActive?.(this.tag, 'onStartSceneAnimation: AttractionAnimation');
      })
      this.getUiContext()?.animateTo({
        duration: 0
      }, () => {
        transitionController?.onInactive?.(this.tag, 'onStartSceneAnimation: AttractionAnimation');
      })
      primarySession.setSidebarBlur(false, false);
    } else if (isNonTraceable) {
      this.applyNonTraceableSceneAnimate(sceneContainerSession);
    } else {
      this.getUiContext()?.animateTo({
        duration: 0,
      }, () => {
        this.restoreSceneRadius(primarySession);
      })
      this.getUiContext()?.animateTo({
        duration: 0,
      }, () => {
        primarySession.opacity = 1.0;
      })
      this.getUiContext()?.animateTo({
        duration: 0,
        onFinish: finishCallback,
      }, () => {
        primarySession.setScaleX(1.0);
      })
      this.getUiContext()?.animateTo({
        duration: 0,
      }, () => {
        primarySession.setScaleY(1.0);
      })
      this.getUiContext()?.animateToImmediately({
        duration: 0,
      }, () => {
        primarySession.setTran(0, 0);
      })
    }
  }

  private restoreSceneRadius(sceneSession: SCBSceneSession | null): void {
    if (!sceneSession) {
      return;
    }
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      sceneSession.floatBorderRadius = 0;
    } else {
      sceneSession.setFloatCornerRadiusConfig();
    }
    this.log.showInfo(`sceneRadius restored, windowMode: ${sceneSession.sceneInfo.windowMode}`);
  }

  private applyNonTraceableSceneAnimate(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession || !sceneContainerSession.primarySession) {
      return;
    }
    sceneContainerSession.addTransitionCount();
    sceneContainerSession.primarySession.isMinimizing = false;
    sceneContainerSession.primarySession.isAttracting = false;
    sceneContainerSession.primarySession.attractionVal = 0.0;
    sceneContainerSession.needRenderVisibility.setVisibilityWithDfx(true, this.tag, 'recoverVisibilityNonTraceable',
      sceneContainerSession.getName());
    const type: string = PageDesktopModel.getInstance().getSceneLaunchType(sceneContainerSession.companionIconInfo);
    sceneContainerSession.needRenderScale.setScaleXWithDfx(1.0, this.tag, 'applyNonTraceableSceneAnimate',
      sceneContainerSession.getName());
    sceneContainerSession.needRenderScale.setScaleYWithDfx(1.0, this.tag, 'applyNonTraceableSceneAnimate',
      sceneContainerSession.getName());
    sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, this.tag, 'onSceneContainerTransitionInNoAni',
      sceneContainerSession.getName());
    SCBSceneHelper.setSceneTranslate(sceneContainerSession, 0, 0);
    SCBSceneHelper.setSceneScale(sceneContainerSession, 0.7);
    SCBSceneHelper.setSceneOpacity(sceneContainerSession, 0);
    this.getUiContext()?.animateToImmediately({
      duration: 0,
      onFinish: () => {
        performanceMonitor.end(type);
        CloseAppManager.getInstance().resetStartAppSubtype();
        CloseAppManager.getInstance().setStartAppType(StartType.APP);
      }
    }, () => {
      SCBSceneHelper.setSceneTranslate(sceneContainerSession, 0, 0);
      SCBSceneHelper.setSceneScale(sceneContainerSession, 1);
      SCBSceneHelper.setSceneOpacity(sceneContainerSession, 1);
    })
  }


  private isBottomInBScreen(scbSceneSession: SCBSceneSession | SCBSpecificSession): boolean {
    return false;
  }

  private getExtraId(): string | null {
    let extraId: string | null = null;
    if (this.isInPanelState(ScenePanelState.APP_CENTER)) {
      extraId = CommonConstants.APPCENTER_ICON_EXTRA_ID;
    }
    return extraId;
  }

  private getTransitionsContext(sceneInfo: SCBSceneInfo): string[] {
    if (sceneInfo.bundleName !== CommonConstants.FILE_MANAGER_BUNDLE) {
      return [sceneInfo.bundleName, sceneInfo.abilityName];
    }

    const params = sceneInfo.want?.parameters;
    if (params && params['fileManagerMode'] && typeof params['fileManagerMode'] === 'string') {
      if (params['fileManagerMode'] == 'RecycleBin') {
        return [CommonConstants.LAUNCHER_BUNDLE, CommonConstants.RECYCLE_BIN_ABILITY];
      } else {
        return [sceneInfo.bundleName, params['fileManagerMode']];
      }
    }
    return [sceneInfo.bundleName, sceneInfo.abilityName];
  }

  private requestSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    this.log.showInfo('[SCBMain]requestSceneSession with sceneInfo:{persistentId: %{public}d, bundleName:%{public}s,' +
      'moduleName:%{public}s, abilityName:%{public}s, needFindOtherScreen:%{public}s}', sceneInfo.persistentId,
      sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName, sceneInfo.needFindOtherScreen);
    if (sceneInfo.needFindOtherScreen) {
      const sceneSession = this.getSceneSessionFromOtherScreen(sceneInfo);
      if (sceneSession !== undefined) {
        sceneSession.sceneInfo.requestId = sceneInfo.requestId;
        sceneInfo.needFindOtherScreen = false;
        this.log.showInfo('[SCBMain]getSceneSessionFromOtherScreen success.');
        return sceneSession;
      }
    }
    if (sceneInfo == null) {
      this.log.showError('sceneInfo null');
      return null;
    }
    if (sceneInfo.persistentId !== 0) {
      this.log.showInfo('[SCBMain]using exist persistentId: ' + sceneInfo.persistentId);
      let scbSceneSession = this.getSceneSessionByPersistentId(sceneInfo.persistentId);
      if (scbSceneSession == null) {
        this.log.showInfo('[SCBMain]not find , new a scene session');
        scbSceneSession = this.createSceneSession(sceneInfo);
      } else {
        scbSceneSession.sceneInfo.requestId = sceneInfo.requestId;
        this.panelProxy.updateRectToAvoidStatusBar(scbSceneSession);
        SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      }
      return scbSceneSession;
    } else {
      const scbSceneSession = this.getSceneSession(sceneInfo);
      if (scbSceneSession) {
        scbSceneSession.sceneInfo.requestId = sceneInfo.requestId;
      }
      if (scbSceneSession == null || sceneInfo.isNewInstance || sceneInfo.isNewAppInstance ||
      PcDockIndepentIconMgr.getInstance().checkIsIndependentIconSession(scbSceneSession)) {
        this.log.showWarn('[SCBMain]getSceneSession is null, new scene session');
        return this.createSceneSession(sceneInfo);
      }
      if (sceneInfo.want !== null) {
        this.log.showInfo('update want persistentId: ' + scbSceneSession.sceneInfo.persistentId);
        sceneSessionManager.updateSceneSessionWant({
          bundleName: scbSceneSession.sceneInfo.bundleName,
          moduleName: scbSceneSession.sceneInfo.moduleName,
          abilityName: scbSceneSession.sceneInfo.abilityName,
          appIndex: scbSceneSession.sceneInfo.appIndex,
          persistentId: scbSceneSession.sceneInfo.persistentId
        }, sceneInfo.want, sceneInfo.requestId);
      }
      return scbSceneSession;
    }
  }

  private createSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    const sceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
    if (sceneSession === null) {
      this.log.showWarn('createSceneSession return null');
      return null;
    }
    if (!this.shouldCreateSessionWhenReachMaxSessionNum(sceneInfo)) {
      this.log.showError('createSceneSession failed, session number is reached max vsync limit.');
      return null;
    }
    let scbSceneSession = new SCBSceneSession(sceneSession, sceneInfo);
    scbSceneSession.sessionData.isNewWant = false;
    this.setSystemOrSupportAppIsEnableSpecified(scbSceneSession);
    this.setSystemOrSupportAppWindowRectAutoSave(scbSceneSession);
    this.setIsWindowRectAutoSave(scbSceneSession);
    this.initSceneWhenCreateSceneSession(scbSceneSession, sceneSession);
    return scbSceneSession;
  }

  private setSystemOrSupportAppIsEnableSpecified(scbSceneSession: SCBSceneSession): void {
    let sceneInfo: SCBSceneInfo = scbSceneSession.sceneInfo;
    if (this.isSystemApp(sceneInfo.bundleName) || this.isSupportRecoverSceneApp(sceneInfo.bundleName)) {
      let key: string = sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
      let isEnableSpecified: boolean | undefined =
        SCBPcScenePanelManager.getInstance().getIsEnableSpecifiedRectAutoSaveMap(key);
      if (isEnableSpecified === undefined) {
        SCBPcScenePanelManager.getInstance().setIsEnableSpecifiedRectAutoSaveMap(key, false);
      }
    }
  }

  private setSystemOrSupportAppWindowRectAutoSave(scbSceneSession: SCBSceneSession): void {
    let info: SCBSceneInfo = scbSceneSession.sceneInfo;
    let key: string = SCBPcScenePanelManager.getInstance().createIsWindowRectAutoSaveKey(info);
    let isWindowRectAutoSave: boolean | undefined =
      SCBPcScenePanelManager.getInstance().getIsWindowRectAutoSaveMap(key);
    if (this.isSystemApp(info.bundleName) || this.isSupportRecoverSceneApp(info.bundleName)) {
      if (isWindowRectAutoSave === undefined) {
        SCBPcScenePanelManager.getInstance().setIsWindowRectAutoSaveMap(key, true);
      }
    }
  }

  private setIsWindowRectAutoSave(scbSceneSession: SCBSceneSession): void {
    let info: SCBSceneInfo = scbSceneSession.sceneInfo;
    let key: string = SCBPcScenePanelManager.getInstance().createIsWindowRectAutoSaveKey(info);
    let isWindowRectAutoSave: boolean | undefined =
      SCBPcScenePanelManager.getInstance().getIsWindowRectAutoSaveMap(key);
    let abilityKey: string = info.bundleName + info.moduleName + info.abilityName;
    let isSaveBySpecifiedFlag: boolean =
      SCBPcScenePanelManager.getInstance().getIsEnableSpecifiedRectAutoSaveMap(abilityKey) ?? false;
    if (isWindowRectAutoSave === undefined || !isWindowRectAutoSave) {
      SCBSceneSessionManager.getInstance().setIsWindowRectAutoSave(key, false, abilityKey, isSaveBySpecifiedFlag);
      return;
    }
    SCBSceneSessionManager.getInstance().setIsWindowRectAutoSave(key, isWindowRectAutoSave,
      abilityKey, isSaveBySpecifiedFlag);
  }

  private isSystemApp(bundleName: string): boolean {
    let isSystemApp = this.systemAppMap.get(bundleName);
    if (isSystemApp != undefined) {
      return isSystemApp;
    } else {
      let applicationFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
      try {
        let applicationInfo = bundleManager.getApplicationInfoSync(bundleName, applicationFlags);
        if (applicationInfo && applicationInfo.systemApp) {
          this.systemAppMap.set(bundleName, true);
          return true;
        }
      } catch (error) {
        this.log.error('call isSystemApp error', error);
      }
      this.systemAppMap.set(bundleName, false);
      return false;
    }
  }

  private isSupportRecoverSceneApp(bundleName: string): boolean {
    if (bundleName === 'cn.wps.office.hap' ||
      bundleName === 'com.haitai.htbrowser' ||
      bundleName === 'com.haitai.htrlbrowser' ||
      bundleName === 'com.haitai.ohos_htbrowser') {
      return true;
    }
    return false;
  }

  private initWindowMaximize(scbSceneSession: SCBSceneSession): boolean {
    if (!scbSceneSession.sceneInfo.isMaximize || !this.isSupportedFullScreen(scbSceneSession)) {
      return false;
    }
    let statusBarHeightPx: number = 0;
    if (viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)) {
      statusBarHeightPx = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenId);
    }
    scbSceneSession.isRecoveredScene = true;
    scbSceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
    scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    let screenInfo = this.getRealScreenInfo(scbSceneSession.currRect.top.getPx());
    let newCurrRect = this.UpdateOutScreenRect(scbSceneSession.lastRect, screenInfo);
    scbSceneSession.currRect.copyFrom(this.getMaximizeRect(scbSceneSession.currRect.top.getPx()));
    let defaultWidth: number = screenInfo.screenWidth * DEFAULT_RATIO;
    let defaultHeight: number = screenInfo.screenHeightLimit * DEFAULT_RATIO;
    let defaultTop: number = (screenInfo.screenHeightLimit - statusBarHeightPx -
    this.dockHeightInVp - defaultHeight) / 2;
    let defaultLeft: number = (screenInfo.screenWidth - defaultWidth) / 2;
    scbSceneSession.lastRect.setPosNum(defaultLeft, defaultTop);
    scbSceneSession.lastRect.setSizeNum(defaultWidth, defaultHeight);
    scbSceneSession.isRecoveredFullScreen = true;
    this.log.showInfo(`init cascade pos and size with maximize, width: ${screenInfo.screenWidth}, ` +
      `height: ${screenInfo.screenHeightLimit} displayId: ${this.screenProperty.screenId}`);
    return true;
  }

  // vp to px by specified dpi ratio. if ratio is invalid, call vp2px instead.
  private vp2pxWithDpiRatio(value: number, dpiRatio?: number): number {
    if (dpiRatio === undefined) {
      dpiRatio = this.screenDpiDensity / ViewModelConstant.BASE_DENSITY;
    }
    if (dpiRatio > 0) {
      return value * dpiRatio;
    } else {
      return vp2px(value);
    }
  }

  // px to vp by specified dpi ratio. if ratio is invalid, call vp2px instead.
  private px2vpWithDpiRatio(value: number, dpiRatio?: number): number {
    if (dpiRatio === undefined) {
      dpiRatio = this.screenDpiDensity / ViewModelConstant.BASE_DENSITY;
    }
    if (dpiRatio > 0) {
      return value / dpiRatio;
    } else {
      return SCBSystemSceneUtils.getInstance().px2vp(this.uiContext, value);
    }
  }

  private setDefaultSizeAndPosition(scbSceneSession: SCBSceneSession): void {
    let displayHeight: number = this.screenProperty.height;
    let displayWidth: number = this.screenProperty.width;
    try {
      let displayInfo: display.Display = display.getDisplayByIdSync(this.screenProperty.screenId);
      this.log.showInfo('[SCBMain] rect displayId: %{public}d, displayHeight: %{public}d, displayWidth: %{public}d',
        displayInfo.id, displayInfo.availableHeight, displayInfo.availableWidth);
      displayHeight = displayInfo.availableHeight;
      displayWidth = displayInfo.availableWidth;
    } catch (err) {
      this.log.showError(`getDisplayByIdSync fail, Code is ${err?.code}, message is ${err?.message}`);
    }
    let sceneInfo: SCBSceneInfo = scbSceneSession.sceneInfo;
    if (CommonUtils.isInvalid(sceneInfo.configWindowWidth) && CommonUtils.isInvalid(sceneInfo.configWindowHeight) &&
    CommonUtils.isEmpty(sceneInfo.configWindowTop) && CommonUtils.isEmpty(sceneInfo.configWindowLeft)) {
      return;
    }
    let left = 0;
    let top = 0;
    let width: number = sceneInfo.configWindowWidth ? this.vp2pxWithDpiRatio(sceneInfo.configWindowWidth) :
      displayWidth * DEFAULT_RATIO;
    if (width >= displayWidth) {
      width = displayWidth;
    } else {
      left = this.parseLeft(sceneInfo.configWindowLeft, width, displayWidth); // 当width 小于屏幕高度时，left才有调整空间
    }
    let height: number = sceneInfo.configWindowHeight ? this.vp2pxWithDpiRatio(sceneInfo.configWindowHeight) :
      displayHeight * DEFAULT_RATIO;
    let statusBarHeightPx: number = 0;
    if (viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)) {
      statusBarHeightPx = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenId);
    }
    if (height >= displayHeight) {
      height = displayHeight;
      top = statusBarHeightPx;
    } else {
      top = this.parseTop(sceneInfo.configWindowTop, height, displayHeight, statusBarHeightPx);
    }
    if (!SCBSceneHelper.nearEqual(left, -1)) {
      scbSceneSession.sceneInfo.windowLeft = left;
    }
    if (!SCBSceneHelper.nearEqual(top, -1)) {
      scbSceneSession.sceneInfo.windowTop = top;
    }
    scbSceneSession.sceneInfo.windowWidth = width;
    scbSceneSession.sceneInfo.windowHeight = height;
    this.log.showInfo('[SCBMain] rect [%{public}d %{public}d %{public}d %{public}d]', left, top, width, height);
  }

  private parseLeft(param: string | undefined, width: number, displayWidth: number): number {
    if (param === undefined) {
      return -1;
    }
    let reg: RegExp = /^(center|left|right)?(\+|-)?(\d{1,4})?$/;
    let matchResult: RegExpMatchArray | null = param.match(reg);
    if (matchResult === null) {
      return -1;
    }
    let align: string = matchResult[1];
    let direction: string = matchResult[2];
    let matchOffset: string = matchResult[3];
    let offset: number = CommonUtils.isEmpty(matchOffset) ? 0 : this.vp2pxWithDpiRatio(Number.parseInt(matchOffset));
    let left: number = offset;
    if ((CommonUtils.isEmpty(align) && CommonUtils.isEmpty(matchOffset)) ||
      (CommonUtils.isEmpty(align) && !CommonUtils.isEmpty(direction))) {
      return -1;
    }
    if (!CommonUtils.isEmpty(align)) {
      if ((CommonUtils.isEmpty(direction) && !CommonUtils.isEmpty(matchOffset)) ||
        (!CommonUtils.isEmpty(direction) && CommonUtils.isEmpty(matchOffset))) {
        return -1;
      }
      if (align === 'center') {
        left = (displayWidth - width) / 2; // 水平居中对齐
        if (CommonUtils.isEmpty(direction) && CommonUtils.isEmpty(matchOffset)) {
          return left;
        }
        left = direction === '+' ? left + offset : left - offset;
      } else if (align === 'left') {
        if (CommonUtils.isEmpty(direction) && CommonUtils.isEmpty(matchOffset)) {
          return 0;
        }
        if (direction === '-') {
          return -1;
        }
      } else if (align === 'right') {
        left = displayWidth - width; // 右对齐
        if (CommonUtils.isEmpty(direction) && CommonUtils.isEmpty(matchOffset)) {
          return left;
        }
        if (direction === '+') {
          return -1;
        }
        left = left - offset;
      } else { // 规范
      }
    }
    if (left < 0) {
      left = 0;
    } else if (left + width > displayWidth) {
      left = displayWidth - width;
    }
    return left;
  }

  private parseTop(param: string | undefined, height: number, displayHeight: number,
    statusBarHeightPx: number): number {
    if (param === undefined) {
      return -1;
    }
    let reg: RegExp = /^(center|top|bottom)?(\+|-)?(\d{1,4})?$/;
    let matchResult: RegExpMatchArray | null = param.match(reg);
    if (matchResult === null) {
      return -1;
    }
    let align: string = matchResult[1];
    let direction: string = matchResult[2];
    let matchOffset: string = matchResult[3];
    let offset: number = CommonUtils.isEmpty(matchOffset) ? 0 : this.vp2pxWithDpiRatio(Number.parseInt(matchOffset));
    let top: number = offset;
    if ((CommonUtils.isEmpty(align) && CommonUtils.isEmpty(matchOffset)) ||
      (CommonUtils.isEmpty(align) && !CommonUtils.isEmpty(direction))) {
      return -1;
    }
    if (!CommonUtils.isEmpty(align)) {
      if ((CommonUtils.isEmpty(direction) && !CommonUtils.isEmpty(matchOffset)) ||
        (!CommonUtils.isEmpty(direction) && CommonUtils.isEmpty(matchOffset))) {
        return -1;
      }
      if (align === 'center') {
        top = (displayHeight - height) / 2 + statusBarHeightPx; // 垂直居中对齐
        if (CommonUtils.isEmpty(direction) && CommonUtils.isEmpty(matchOffset)) {
          return top;
        }
        top = direction === '+' ? top + offset : top - offset;
      } else if (align === 'top') {
        if (CommonUtils.isEmpty(direction) && CommonUtils.isEmpty(matchOffset)) {
          return statusBarHeightPx; // 顶部对齐，需要在状态栏下
        }
        if (direction === '-') {
          return -1;
        }
      } else if (align === 'bottom') {
        top = displayHeight + statusBarHeightPx - height; // 底部对齐
        if (CommonUtils.isEmpty(direction) && CommonUtils.isEmpty(matchOffset)) {
          return top;
        }
        if (direction === '+') {
          return -1;
        }
        top = top - offset;
      } else { // 规范
      }
    }
    if (top < statusBarHeightPx) {
      top = statusBarHeightPx;
    } else if ((top + height) > (displayHeight + statusBarHeightPx)) {
      top = displayHeight + statusBarHeightPx - height;
    }
    return top;
  }

  private getContainerSessionForMultiInstances(key: string): SCBSceneContainerSession | null {
    let lastContainerSession: SCBSceneContainerSession | null = null;
    let isRecordedHideSession = false;
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      const containerSession = this.containerSessionList[i];
      const primarySession = containerSession?.primarySession;
      if (containerSession.isTopmost()) {
        continue;
      }
      if (!primarySession || primarySession.isClosing) {
        continue;
      }
      let elementKey = primarySession.sceneInfo.bundleName + primarySession.sceneInfo.moduleName +
      primarySession.sceneInfo.abilityName;
      if (key !== elementKey) {
        continue;
      }
      if (primarySession.isActive) {
        lastContainerSession = containerSession;
        break;
      }
      if (isRecordedHideSession) {
        continue;
      }
      lastContainerSession = containerSession;
      isRecordedHideSession = true;
    }
    return lastContainerSession;
  }

  private setSizeAndPositionForMultiInstances(scbSceneSession: SCBSceneSession): boolean {
    let info: SCBSceneInfo = scbSceneSession.sceneInfo;
    let key: string = info.bundleName + info.moduleName + info.abilityName;
    const lastContainerSession: SCBSceneContainerSession | null = this.getContainerSessionForMultiInstances(key);
    if (!lastContainerSession || lastContainerSession.isSplit) {
      return false;
    }
    let lastSCBSceneSession: SCBSceneSession | null = lastContainerSession.primarySession;
    if (!lastSCBSceneSession) {
      return false;
    }

    scbSceneSession.isRecoveredScene = true;
    let statusBarHeightPx: number = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenId);
    if (lastSCBSceneSession.isMaximizeFloating ||
      lastSCBSceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      scbSceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
      let screenInfo = this.getRealScreenInfo(lastSCBSceneSession.currRect.top.getPx());
      let isDockAutoHide = AppStorage.get<boolean>('isDockAutoHide');
      scbSceneSession.currRect.setSizeNum(screenInfo.screenWidth, isDockAutoHide ? screenInfo.screenHeight :
        screenInfo.screenHeightLimit);
      scbSceneSession.currRect.setPosNum(0, isDockAutoHide ? screenInfo.fullScreenTop : screenInfo.maxTop);
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      let newCurrRect = this.UpdateOutScreenRect(lastSCBSceneSession.lastRect, screenInfo);
      let width: number = lastSCBSceneSession.lastRect.width.getPx();
      let height: number = lastSCBSceneSession.lastRect.height.getPx();
      if (Math.abs(width) < MINI_VALUE && Math.abs(height) < MINI_VALUE) {
        let defaultWidth: number = screenInfo.screenWidth * DEFAULT_RATIO;
        let defaultHeight: number = screenInfo.screenHeightLimit * DEFAULT_RATIO;
        let defaultTop: number = (screenInfo.screenHeightLimit - statusBarHeightPx -
        this.dockHeightInVp - defaultHeight) / 2;
        let defaultLeft: number = (screenInfo.screenWidth - defaultWidth) / 2;
        lastSCBSceneSession.lastRect.setPosNum(defaultLeft, defaultTop);
        lastSCBSceneSession.lastRect.setSizeNum(defaultWidth, defaultHeight);
        newCurrRect = this.UpdateOutScreenRect(lastSCBSceneSession.lastRect, screenInfo);
      }
      scbSceneSession.isRecoveredFullScreen = true;
      scbSceneSession.lastRect.setRect(newCurrRect.left, newCurrRect.top, newCurrRect.width, newCurrRect.height);
      this.log.showInfo('setSizeAndPositionForMultiInstances id: ' + scbSceneSession.session.persistentId +
        ', lastRect: ' + scbSceneSession.lastRect.printPx());
    } else {
      let windowWidth: number = lastSCBSceneSession.currRect.width.getVp();
      let windowHeight: number = lastSCBSceneSession.currRect.height.getVp();
      let translateX: number = lastSCBSceneSession.currRect.left.getVp();
      let translateY: number = lastSCBSceneSession.currRect.top.getVp();
      this.log.showInfo(`currRect.translateX: ${translateX}, currRect.translateX: ${translateY}`);
      if (this.changeSessionFullScreenIfNeed(scbSceneSession, lastSCBSceneSession, windowWidth, windowHeight)) {
        return true;
      }
      const initPosRet = this.getInitPosFromLastSession(windowWidth, windowHeight,
        SCBSystemSceneUtils.getInstance().px2vp(this.uiContext, statusBarHeightPx),
        lastContainerSession.isSplit, lastSCBSceneSession);
      translateX = initPosRet.translateX;
      translateY = initPosRet.translateY;
      scbSceneSession.currRect.setPosNum(vp2px(translateX), vp2px(translateY));
      scbSceneSession.currRect.setSizeNum(vp2px(windowWidth), vp2px(windowHeight));
    }
    return true;
  }

  private changeSessionFullScreenIfNeed(scbSceneSession: SCBSceneSession, lastSCBSceneSession: SCBSceneSession,
    windowWidth: number, windowHeight: number): boolean {
    let screenInfo = this.getRealScreenInfo(lastSCBSceneSession.currRect.top.getPx());
    let screenWidth = px2vp(screenInfo.screenWidth);
    let screenHeight = px2vp(screenInfo.screenHeightLimit);
    // 如果新打开窗口宽高超过所在屏幕宽高，则设置窗口全屏
    if (windowWidth > screenWidth || windowHeight > screenHeight) {
      scbSceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
      scbSceneSession.currRect.setSizeNum(screenInfo.screenWidth, screenInfo.screenHeightLimit);
      scbSceneSession.currRect.setPosNum(0, screenInfo.maxTop);
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      let scbLastRect = lastSCBSceneSession.currRect.copy();
      let newCurrRect = this.UpdateOutScreenRect(scbLastRect, screenInfo);
      scbSceneSession.lastRect.setRect(newCurrRect.left, newCurrRect.top, newCurrRect.width, newCurrRect.height);
      scbSceneSession.isRecoveredFullScreen = true;
      this.log.showInfo('changeSessionFullScreenIfNeed id: ' + scbSceneSession.session.persistentId + ', lastRect: ' +
      scbSceneSession.lastRect.printPx());
      return true;
    }
    return false;
  }

  private isWindowRectAutoSave(info: SCBSceneInfo): boolean {
    if (this.isSystemApp(info.bundleName) || this.isSupportRecoverSceneApp(info.bundleName)) {
      return true;
    }
    let key: string = SCBPcScenePanelManager.getInstance().createIsWindowRectAutoSaveKey(info);
    return SCBPcScenePanelManager.getInstance().getIsWindowRectAutoSaveMap(key) ?? false;
  }

  private recoverPosIfNeeded(scbSceneSession: SCBSceneSession): boolean {
    let info = scbSceneSession.sceneInfo;
    if (!this.isWindowRectAutoSave(info)) {
      this.log.showInfo('app not support recover from scene memory, bundleName: ' + info.bundleName);
      return false;
    }
    let sceneMemoryKey = this.createSceneMemoryKey(info);
    this.log.showInfo('recoverPosIfNeeded, sceneMemoryKey: ' + sceneMemoryKey);
    let sceneMemoryInfo = this.sceneMemoryInfoMap.get(sceneMemoryKey);
    if (sceneMemoryInfo === undefined) {
      try {
        const context = AppStorage.get<Context>('intentPageContext');
        const store = PreferenceStore.getInstance(context?.getApplicationContext());
        let sceneMemoryInfoDefault =
          new SCBSceneMemoryInfo(SCBSceneMode.UNDEFINED, false, this.screenProperty.screenId,
            INVALID_DPI) as object;
        const sceneMemoryInfoPersisted = store.getSync(sceneMemoryKey, sceneMemoryInfoDefault);
        if (sceneMemoryInfoPersisted === undefined) {
          return false;
        }
        sceneMemoryInfo = this.transferObjectToSCBSceneMemoryInfo(sceneMemoryInfoPersisted as object);
        if (sceneMemoryInfo.windowMode === SCBSceneMode.UNDEFINED) {
          this.log.showInfo('recoverPosIfNeeded, no sceneMemoryInfo in database');
          return false;
        }
      } catch (error) {
        this.log.showError(`get sceneMemoryInfo from database error, message: ${error.message}`);
      }
    }
    if (sceneMemoryInfo !== undefined) {
      let key = info.bundleName + info.moduleName + info.abilityName;
      const launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(key);
      let isSingleton = launchType === bundleManager.LaunchType.SINGLETON;
      this.log.showInfo('recoverPosIfNeeded, launchType ' + launchType);
      let screenInfo = this.getRealScreenInfo(sceneMemoryInfo.currRect.top.getPx());
      this.log.showInfo(`recoverPosIfNeeded screenInfo: ${JSON.stringify(screenInfo)}`);
      let persistentId: ESObject = scbSceneSession.session.persistentId;
      let haveMultInstances = this.checkMultiInstances(key, persistentId);
      if (sceneMemoryInfo.windowMode === SCBSceneMode.FLOATING) {
        if (sceneMemoryInfo.currRect.width.getPx() === null || sceneMemoryInfo.currRect.height.getPx() === null) {
          this.log.showInfo('recoverPosIfNeeded, not available width and height, return ');
          return false;
        }
        if (isSingleton || !haveMultInstances) {
          this.recoverFloatingScene(scbSceneSession, sceneMemoryInfo, screenInfo);
          return true;
        }
      } else if (sceneMemoryInfo.windowMode === SCBSceneMode.FULLSCREEN) {
        if (sceneMemoryInfo.lastRect.width.getPx() === null || sceneMemoryInfo.lastRect.height.getPx() === null) {
          this.log.showInfo('recoverPosIfNeeded, last rect not available width and height, return ');
          return false;
        }
        if (isSingleton || !haveMultInstances) {
          this.recoverMaximizeScene(scbSceneSession, sceneMemoryInfo, screenInfo);
          return true;
        }
      } else if (sceneMemoryInfo.windowMode === SCBSceneMode.PRIMARY ||
        sceneMemoryInfo.windowMode === SCBSceneMode.SECONDARY) {
        if (sceneMemoryInfo.lastRect.width.getPx() === null || sceneMemoryInfo.lastRect.height.getPx() === null) {
          this.log.showInfo('recoverPosIfNeeded, last rect not available width and height, return ');
          return false;
        }
        if (isSingleton || !haveMultInstances) {
          this.recoverSplitScene(scbSceneSession, sceneMemoryInfo, screenInfo);
          return true;
        }
      }
    }
    return false;
  }

  private recoverSplitScene(scbSceneSession: SCBSceneSession, sceneMemoryInfo: SCBSceneMemoryInfo,
    screenInfo: RealScreenInfo): void {
    let lastRect = sceneMemoryInfo.lastRect;
    let curDpi: number = this.screenDpiDensity;
    if (sceneMemoryInfo.lastDpi > 0 && curDpi !== sceneMemoryInfo.lastDpi) {
      let dpiRatio = curDpi / sceneMemoryInfo.lastDpi;
      lastRect = this.calcRectAfterDpiChange(lastRect, dpiRatio);
    }
    lastRect = this.UpdateOutScreenRect(lastRect, screenInfo);
    scbSceneSession.currRect.setRect(lastRect.left, lastRect.top, lastRect.width, lastRect.height);
  }

  private recoverFloatingScene(scbSceneSession: SCBSceneSession, sceneMemoryInfo: SCBSceneMemoryInfo,
    screenInfo: RealScreenInfo): void {
    if (this.exceedScreenSizeRecoverMax(scbSceneSession, screenInfo, sceneMemoryInfo)) {
      return;
    }
    this.exceedScreenSizeRecoverInScreen(scbSceneSession, screenInfo, sceneMemoryInfo);
  }

  private exceedScreenSizeRecoverInScreen(scbSceneSession: SCBSceneSession, screenInfo: RealScreenInfo,
    sceneMemoryInfo: SCBSceneMemoryInfo): void {
    let curDpi: number = this.screenDpiDensity;
    let currRect = sceneMemoryInfo.currRect;
    if (sceneMemoryInfo.lastDpi > 0 && curDpi !== sceneMemoryInfo.lastDpi) {
      let dpiRatio = curDpi / sceneMemoryInfo.lastDpi;
      currRect = this.calcRectAfterDpiChange(currRect, dpiRatio);
    }
    let newCurrRect = this.UpdateOutScreenRect(currRect, screenInfo);
    scbSceneSession.currRect.setRect(newCurrRect.left, newCurrRect.top, newCurrRect.width, newCurrRect.height);
  }

  private UpdateOutScreenRect(currRect: SCBSessionRect, screenInfo: RealScreenInfo): SCBSessionRect {
    let top = currRect.top;
    let left = currRect.left;
    let width = currRect.width;
    let height = currRect.height;
    if (this.isWindowExceedScreenSize(screenInfo, currRect)) {
      if (width.getPx() > screenInfo.screenWidth) {
        width.setNumber(screenInfo.screenWidth);
        left.setNumber(0);
      }
      if (currRect.height.getPx() > screenInfo.screenHeightLimit) {
        height.setNumber(screenInfo.screenHeightLimit);
        top.setNumber(screenInfo.maxTop);
      }
    } else {
      if (left.getPx() < 0) {
        left.setNumber(0);
      }
      if (left.getPx() + width.getPx() > screenInfo.screenWidth) {
        left.setNumber(screenInfo.screenWidth - width.getPx());
      }
      if (top.getPx() < screenInfo.maxTop) {
        top.setNumber(screenInfo.maxTop);
      }
      if ((top.getPx() + height.getPx()) > screenInfo.maxBottom) {
        top.setNumber(screenInfo.maxBottom - height.getPx());
      }
    }
    return new SCBSessionRect(left.getPx(), top.getPx(), width.getPx(), height.getPx());
  }


  private calcRectAfterDpiChange(currRect: SCBSessionRect, dpiRatio: number): SCBSessionRect {
    return new SCBSessionRect(currRect.left.getPx(), currRect.top.getPx(), currRect.width.getPx() * dpiRatio,
      currRect.height.getPx() * dpiRatio);
  }

  private isWindowExceedScreenSize(screenInfo: RealScreenInfo, currRect: SCBSessionRect): boolean {
    if (currRect.width.getPx() > screenInfo.screenWidth || currRect.height.getPx() > (screenInfo.screenHeightLimit)) {
      return true;
    }
    return false;
  }

  private isSupportedFullScreen(scbSceneSession: SCBSceneSession): boolean {
    const supportModes = this.getSupportWindowModes(scbSceneSession.sceneInfo);
    for (let element of supportModes) {
      if (element === bundleManager.SupportWindowMode.FULL_SCREEN) {
        return true;
      }
    }
    this.log.showInfo('isSupportedFullScreen: window mode not support full screen');
    return false;
  }

  private exceedScreenSizeRecoverMax(scbSceneSession: SCBSceneSession, screenInfo: RealScreenInfo,
    sceneMemoryInfo: SCBSceneMemoryInfo): boolean {
    //超出限制范围的窗口恢复
    let curDpi: number = this.screenDpiDensity;
    let currRect = sceneMemoryInfo.currRect;
    if (sceneMemoryInfo.lastDpi > 0 && curDpi !== sceneMemoryInfo.lastDpi) {
      let dpiRatio = curDpi / sceneMemoryInfo.lastDpi;
      currRect = this.calcRectAfterDpiChange(currRect, dpiRatio);
    }
    if (this.isWindowExceedScreenSize(screenInfo, currRect) && this.isSupportedFullScreen(scbSceneSession)) {
      if (scbSceneSession.layoutFullScreen || AppStorage.get<boolean>('isDockAutoHide')) {
        scbSceneSession.currRect.setPosNum(0, screenInfo.fullScreenTop);
        scbSceneSession.currRect.setSizeNum(screenInfo.screenWidth, screenInfo.screenHeight);
      } else {
        scbSceneSession.currRect.setPosNum(0, screenInfo.maxTop);
        scbSceneSession.currRect.setSizeNum(screenInfo.screenWidth, screenInfo.screenHeightLimit);
      }
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      scbSceneSession.isRecoveredFullScreen = true;
      SCBSceneHelper.updateLastDpi(scbSceneSession, this.screenDpiDensity);
      currRect = this.UpdateOutScreenRect(currRect, screenInfo);
      scbSceneSession.lastRect.setRect(currRect.left, currRect.top, currRect.width, currRect.height);
      this.log.showInfo('exceedScreenSizeRecoverMax id: ' + scbSceneSession.session.persistentId + ', lastRect: ' +
      scbSceneSession.lastRect.printPx());
      return true;
    }
    return false;
  }

  private checkMultiInstances(key: string, persistentId: number): boolean {
    let haveMultiInstances = false;
    for (let element of this.containerSessionList) {
      let sceneSession = element.primarySession;
      if (!sceneSession || sceneSession.session.persistentId === persistentId) {
        continue;
      }
      let elementKey = SCBPcScenePanelManager.getInstance().createIsWindowRectAutoSaveKey(sceneSession.sceneInfo);
      if (elementKey === key) {
        haveMultiInstances = true;
        break;
      }
    }
    return haveMultiInstances;
  }

  private isWhitelistApp(scbSceneSession: SCBSceneSession | null): boolean {
    return false;
  }

  private getSupportWindowModes(sceneInfo: SCBSceneInfo): bundleManager.SupportWindowMode[] {
    if (sceneInfo.supportWindowModes !== null &&
      sceneInfo.supportWindowModes !== undefined &&
      sceneInfo.supportWindowModes.length !== 0) {
      return sceneInfo.supportWindowModes;
    }
    let queryKey = sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
    let supportModes = SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo(queryKey);
    this.log.showDebug(`getSupportWindowModes: bundleName: ${sceneInfo.bundleName} ` +
      `supportWindowModes ${JSON.stringify(supportModes)}}`);
    if (supportModes) {
      return supportModes;
    }
    return [];
  }

  private createSceneMemoryKey(info: SCBSceneInfo): string {
    let abilityKey: string = info.bundleName + info.moduleName + info.abilityName;
    let specifiedFlag: string = info.specifiedFlag ?? '';
    let isEnableSpecified: boolean =
      SCBPcScenePanelManager.getInstance().getIsEnableSpecifiedRectAutoSaveMap(abilityKey) ?? false;
    if (!isEnableSpecified) {
      specifiedFlag = '';
    }
    return info.bundleName + info.moduleName + info.abilityName + specifiedFlag;
  }

  private supportedOnlyFullScreen(scbSceneSession: SCBSceneSession): boolean {
    const supportModes = this.getSupportWindowModes(scbSceneSession.sceneInfo);
    this.log.showInfo('initCascadePosAndSize supportmodes ' + JSON.stringify(supportModes) + ' windowMode ' +
    scbSceneSession.sceneInfo.windowMode + ' windowMode ' + scbSceneSession.sceneInfo.windowMode);

    let windowTop = 0;
    let sceneMemoryKey = this.createSceneMemoryKey(scbSceneSession.sceneInfo);
    this.log.showInfo('supportedOnlyFullScreen, sceneMemoryKey: ' + sceneMemoryKey);
    let sceneMemoryInfo = this.sceneMemoryInfoMap.get(sceneMemoryKey);
    if (sceneMemoryInfo === undefined) {
      try {
        const context: Context | undefined = AppStorage.get<Context>('intentPageContext');
        const store = PreferenceStore.getInstance(context?.getApplicationContext());
        let sceneMemoryInfoDefault =
          new SCBSceneMemoryInfo(SCBSceneMode.UNDEFINED, false, this.screenProperty.screenId,
            INVALID_DPI) as object;
        const sceneMemoryInfoPersisted = store.getSync(sceneMemoryKey, sceneMemoryInfoDefault);
        if (sceneMemoryInfoPersisted !== undefined) {
          sceneMemoryInfo = this.transferObjectToSCBSceneMemoryInfo(sceneMemoryInfoPersisted as object);
          if (sceneMemoryInfo.windowMode === SCBSceneMode.UNDEFINED) {
            sceneMemoryInfo = undefined;
            this.log.showInfo('recoverPosIfNeeded, no sceneMemoryInfo in database');
          }
        }
      } catch (error) {
        this.log.showError(`get sceneMemoryInfo from database error, message: ${error.message}`);
      }
    }
    if (sceneMemoryInfo !== undefined) {
      windowTop = sceneMemoryInfo.currRect.top.getPx();
    }
    let screenInfo = this.getRealScreenInfo(windowTop);
    if ((supportModes != null && supportModes.length === 1 &&
      supportModes[0] === bundleManager.SupportWindowMode.FULL_SCREEN)) {
      if (scbSceneSession.layoutFullScreen || sSCBOobeManager.isEnable()) {
        scbSceneSession.currRect.setSizeNum(screenInfo.screenWidth, screenInfo.screenHeight);
        scbSceneSession.currRect.setPosNum(0, screenInfo.fullScreenTop);
      } else {
        scbSceneSession.currRect.setSizeNum(screenInfo.screenWidth, screenInfo.screenHeightLimit);
        scbSceneSession.currRect.setPosNum(0, screenInfo.maxTop);
      }
      scbSceneSession.saveLastRect();
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      return true;
    }
    return false;
  }

  private transferRect(data: object): SCBSessionRect {
    let left: number = data['left']['value'];
    let top: number = data['top']['value'];
    let width: number = data['width']['value'];
    let height: number = data['height']['value'];
    return new SCBSessionRect(left, top, width, height);
  }

  private transferObjectToSCBSceneMemoryInfo(data: object): SCBSceneMemoryInfo {
    let sceneMemoryInfo = new SCBSceneMemoryInfo(SCBSceneMode.UNDEFINED, false, this.screenProperty.screenId,
      INVALID_DPI);
    let currRect = this.transferRect((data as object)['currRect']);
    let lastRect = this.transferRect((data as object)['lastRect']);

    sceneMemoryInfo.currRect = currRect;
    sceneMemoryInfo.lastRect = lastRect;
    sceneMemoryInfo.windowMode = (data as object)['windowMode'] as SCBSceneMode;
    sceneMemoryInfo.layoutFullScreen = (data as object)['layoutFullScreen'] as boolean;
    sceneMemoryInfo.displayId = (data as object)['displayId'] as number;
    sceneMemoryInfo.lastDpi = (data as object)['lastDpi'] as number;
    return sceneMemoryInfo;
  }

  private getFullScreenWindowHeight(scbSceneSession: SCBSceneSession): number {
    if (!scbSceneSession) {
      return this.screenProperty.height;
    }
    this.log.showInfo(`getFullScreenWindowHeight maximinze in fullscreen`);
    return this.screenProperty.height;
  }

  private calcFloatingWindowSize(scbSceneSession: SCBSceneSession,
    specifiedRect?: sceneSessionManager.SessionRect): SCBSessionRect {
    const statusBarHeight: number =
      SCBSystemSceneUtils.getInstance().getStatusBarHeightVP(this.uiContext, this.screenProperty.screenId);
    const screenWidthInVp = px2vp(this.screenProperty.width);
    const screenHeightInVp = px2vp(this.screenProperty.height);
    let info = scbSceneSession.sceneInfo;
    const limitRect: ViewArea = {
      left: 0,
      top: statusBarHeight,
      width: screenWidthInVp,
      height: screenHeightInVp - statusBarHeight - this.dockHeightInVp
    }
    let windowLeft: number = specifiedRect?.posX_ ?? info.windowLeft;
    let windowTop: number = specifiedRect?.posY_ ?? info.windowTop;
    const windowHeight: number = specifiedRect?.height_ ?? info.windowHeight;
    const windowWidth: number = specifiedRect?.width_ ?? info.windowWidth;
    let windowSize: WindowSizeResult = this.getDefaultWindowSize(scbSceneSession, screenWidthInVp, screenHeightInVp,
      windowWidth, windowHeight);
    const dpiRatio = this.screenDpiDensity / ViewModelConstant.BASE_DENSITY;
    let defaultWidth = this.scbVp2RealVpWithDpiRatio(windowSize.width, dpiRatio);
    let defaultHeight = this.scbVp2RealVpWithDpiRatio(windowSize.height, dpiRatio);
    const ret = this.calcWindowSizeByLimits(scbSceneSession, defaultWidth, defaultHeight);
    defaultWidth = this.realVp2ScbVpWithDpiRatio(ret.width, dpiRatio);
    defaultHeight = this.realVp2ScbVpWithDpiRatio(ret.height, dpiRatio);
    let translateX = limitRect.left + (limitRect.width - defaultWidth) * HALF;
    let translateY = limitRect.top + (limitRect.height - defaultHeight) * HALF;
    let key = info.bundleName + info.moduleName + info.abilityName;
    const initPosRet = this.getInitPos(defaultWidth, defaultHeight, translateX, translateY, key);
    translateX = initPosRet.translateX;
    translateY = initPosRet.translateY;
    let titleHeight = StyleConstants.DEFAULT_CONTAINER_TITLE_HEIGHT;
    const posCollision = this.positionalCollision(windowLeft, windowTop, defaultWidth, defaultHeight, titleHeight);
    translateX = posCollision.translateX !== INVALID_POSITION ? posCollision.translateX : translateX;
    translateY = posCollision.translateY !== INVALID_POSITION ? posCollision.translateY : translateY;
    let result = new SCBSessionRect(vp2px(translateX), vp2px(translateY), vp2px(defaultWidth), vp2px(defaultHeight));
    return result;
  }

  private positionalCollision(windowLeft: number, windowTop: number, defaultWidth: number,
    defaultHeight: number, titleHeight: number): InitPosType {
    let translateX = INVALID_POSITION;
    let translateY = INVALID_POSITION;
    let screenInfo = this.getRealScreenInfo(windowTop);
    const screenWidthInVp = px2vp(screenInfo.screenWidth);
    const minMargin: number = 48;
    if (windowLeft !== undefined && windowTop !== undefined) {
      const minTranslateX = minMargin - defaultWidth;
      const maxTranslateX = screenWidthInVp - minMargin;
      const minTranslateY = px2vp(screenInfo.maxTop);
      const maxTranslateY = px2vp(screenInfo.maxBottom) - titleHeight;
      translateX = Math.max(minTranslateX, Math.min(maxTranslateX, px2vp(windowLeft)));
      translateY = Math.max(minTranslateY, Math.min(maxTranslateY, px2vp(windowTop)));
      return new InitPosType(translateX, translateY);
    }

    if (windowLeft !== undefined && windowLeft > 0) {
      windowLeft = px2vp(windowLeft);
      if (windowLeft + defaultWidth <= screenWidthInVp) {
        translateX = windowLeft;
      } else {
        translateX = 0;
      }
    } else if (windowLeft !== undefined && windowLeft <= 0) {
      translateX = 0;
    }

    if (windowTop !== undefined && windowTop > px2vp(screenInfo.maxTop)) {
      windowTop = px2vp(windowTop);
      if (windowTop + defaultHeight > px2vp(screenInfo.screenHeightLimit) ||
        windowTop > px2vp(screenInfo.screenHeightLimit)) {
        translateY = px2vp(screenInfo.maxTop);
      } else {
        translateY = windowTop;
      }
    } else if (windowTop !== undefined && windowTop <= px2vp(screenInfo.maxTop)) {
      translateY = px2vp(screenInfo.maxTop);
    }
    return new InitPosType(translateX, translateY);
  }

  private getInitPos(defaultWidth: number, defaultHeight: number, translateX: number,
    translateY: number, key: string): InitPosType {
    let statusBarHeight: number =
      SCBSystemSceneUtils.getInstance().getStatusBarHeightVP(this.uiContext, this.screenId);
    let temTranslateY: number = translateY;
    if (temTranslateY < statusBarHeight) {
      temTranslateY = statusBarHeight;
    }

    let lastSCBSceneSession: SCBSceneSession | null = null;
    let isSplit = false;

    const lastContainerSession: SCBSceneContainerSession | null = this.getContainerSessionForPosInit(key);
    if (lastContainerSession) {
      lastSCBSceneSession = lastContainerSession.primarySession;
      isSplit = lastContainerSession.isSplit;
    }

    if (!lastSCBSceneSession) {
      this.log.showInfo(`getInitPos, no last scene session, result:(${translateX},${temTranslateY})`);
      return new InitPosType(translateX, temTranslateY);
    }

    if (lastSCBSceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      return new InitPosType(translateX, temTranslateY);
    }

    return this.getInitPosFromLastSession(defaultWidth, defaultHeight, statusBarHeight, isSplit, lastSCBSceneSession);
  }

  private getInitPosFromLastSession(defaultWidth: number, defaultHeight: number, statusBarHeight: number,
    isSplit: boolean, lastSCBSceneSession: SCBSceneSession): InitPosType {
    let realTitleHeight: number = StyleConstants.DEFAULT_CONTAINER_TITLE_HEIGHT;
    const screenWidthInVp = px2vp(this.screenProperty.width);
    const screenHeightInVp = px2vp(this.screenProperty.height);
    let lastLeft: number = lastSCBSceneSession.currRect.left.getVp();
    let lastTop: number = lastSCBSceneSession.currRect.top.getVp();
    if (isSplit || lastSCBSceneSession.isMaximizeFloating) {
      lastLeft = lastSCBSceneSession.lastRect.left.getVp();
      lastTop = lastSCBSceneSession.lastRect.top.getVp();
    }
    const customDecorHeight: number = sceneSessionManager.getCustomDecorHeight(
      lastSCBSceneSession.session.persistentId);
    if (customDecorHeight !== 0 && customDecorHeight !== realTitleHeight) {
      realTitleHeight = customDecorHeight;
    }

    let stackingOffset = (realTitleHeight / 2 + WINDOW_INTERVAL);
    let calcTransX = lastLeft + stackingOffset;
    let calcTransY = lastTop + stackingOffset;
    let screenInfo = this.getRealScreenInfo(vp2px(calcTransY));
    if (calcTransX < WINDOW_AVOIDANCE || calcTransX + defaultWidth > (screenWidthInVp - WINDOW_AVOIDANCE)) {
      calcTransX = WINDOW_AVOIDANCE;
      calcTransY = statusBarHeight + WINDOW_AVOIDANCE;
    }

    let bottomThreshold: number = screenInfo.maxTop + screenInfo.screenHeightLimit;
    if (calcTransY + defaultHeight > (px2vp(bottomThreshold) - WINDOW_AVOIDANCE) ||
      calcTransY > (px2vp(bottomThreshold) - WINDOW_AVOIDANCE)) {
      calcTransX = calcTransX === WINDOW_AVOIDANCE ? WINDOW_AVOIDANCE : lastLeft + stackingOffset;
      calcTransY = statusBarHeight + WINDOW_AVOIDANCE;
    }
    if (defaultWidth > (screenWidthInVp - WINDOW_AVOIDANCE * 2)) {
      calcTransX = (screenWidthInVp - defaultWidth) / 2;
    }
    let sessionMaxHeight = px2vp(screenInfo.maxBottom) - px2vp(screenInfo.maxTop);
    if (defaultHeight > sessionMaxHeight - WINDOW_AVOIDANCE * 2) {
      calcTransY = (sessionMaxHeight - defaultHeight) / 2 + px2vp(screenInfo.maxTop);
    }
    this.log.showInfo(`getInitPosFromLastSession result:(${calcTransX},${calcTransY})`);
    return new InitPosType(calcTransX, calcTransY);
  }

  /**
   * For singleton app, try to get the newest active session from all apps.
   * For multiton app, try to get the newest active session from all instances of this app.
   * If there's no active instance for multiton app, treat it as a singleton app.
   * If there's no active window, try to get the newest background but not on closing session.
   * @returns
   */
  private getContainerSessionForPosInit(key: string): SCBSceneContainerSession | null {
    let lastContainerSession: SCBSceneContainerSession | null = null;
    let lastMultiInstancesContainerSession: SCBSceneContainerSession | null = null;
    let isRecordedHideSession = false;
    let isRecordedActiveSession = false;
    for (let i = this.containerSessionList.length - 1; i >= 0; i--) {
      const containerSession = this.containerSessionList[i];
      const primarySession = containerSession?.primarySession;
      if (containerSession.isTopmost()) {
        continue;
      }
      if (!primarySession || containerSession.isPendingResizeInPcMode) {
        continue;
      }
      if (primarySession.isActive) {
        if (!isRecordedActiveSession) {
          lastContainerSession = containerSession;
          isRecordedActiveSession = true;
        }
        let elementKey = primarySession.sceneInfo.bundleName + primarySession.sceneInfo.moduleName +
        primarySession.sceneInfo.abilityName;
        if (key === elementKey) {
          lastMultiInstancesContainerSession = containerSession;
          break;
        }
        continue;
      }
      if (primarySession.isClosing || isRecordedHideSession || isRecordedActiveSession || !primarySession.isActive) {
        continue;
      }
      lastContainerSession = containerSession;
      isRecordedHideSession = true;
    }
    if (lastMultiInstancesContainerSession) {
      lastContainerSession = lastMultiInstancesContainerSession;
    }
    return lastContainerSession;
  }

  private calcWindowSizeByLimits(scbSceneSession: SCBSceneSession, defaultWidth: number,
    defaultHeight: number): WindowSizeResult {
    const bundleName = scbSceneSession.sceneInfo.bundleName;
    const moduleName = scbSceneSession.sceneInfo.moduleName;
    const abilityName = scbSceneSession.sceneInfo.abilityName;
    this.log.showInfo('calcWindowSizeByLimits bundleName: ' + bundleName + ', moduleName: ' +
      moduleName + ',abilityName: ' + abilityName);
    const querykey = bundleName + moduleName + abilityName;
    const windowSize = SCBSceneSessionManager.getInstance().getAbilityWindowSize(querykey);
    let result = new WindowSizeResult();
    if (windowSize == null) {
      this.log.showInfo('window size is null or pc compatibility mode not support');
      result.width = defaultWidth;
      result.height = defaultHeight;
      return result;
    }

    const customWindowLimits = new WindowSizeLimits();
    customWindowLimits.initAllWithSceneSession(windowSize, scbSceneSession);

    let maxFloatingWindowSize: number = 1920;
    try {
      maxFloatingWindowSize = sceneSessionManager.getSystemConfig().maxFloatingWindowSize;
    } catch (err) {
      this.log.showError(`get system config faild, ${err}`);
    }
    const MAX_FLOATING_WINDOW_SIZE_: number = maxFloatingWindowSize;
    const MIN_FLOATING_WIDTH: number = 320;
    const MIN_FLOATING_HEIGHT: number = 72;
    const TITLE_HEIGHT: number = 37;
    const FRAME_WIDTH: number = 5;

    const systemSizeLimits = new WindowSizeLimits();
    systemSizeLimits.initSize(MAX_FLOATING_WINDOW_SIZE_, MIN_FLOATING_WIDTH,
      MAX_FLOATING_WINDOW_SIZE_, MIN_FLOATING_HEIGHT);

    const newSizeLimits = systemSizeLimits;

    // calculate new limit size
    if (systemSizeLimits.minWindowWidth <= customWindowLimits.maxWindowWidth &&
      customWindowLimits.maxWindowWidth <= systemSizeLimits.maxWindowWidth) {
      newSizeLimits.maxWindowWidth = customWindowLimits.maxWindowWidth;
    }
    if (systemSizeLimits.minWindowHeight <= customWindowLimits.maxWindowHeight &&
      customWindowLimits.maxWindowHeight <= systemSizeLimits.maxWindowHeight) {
      newSizeLimits.maxWindowHeight = customWindowLimits.maxWindowHeight;
    }
    if (systemSizeLimits.minWindowWidth <= customWindowLimits.minWindowWidth &&
      customWindowLimits.minWindowWidth <= systemSizeLimits.maxWindowWidth) {
      newSizeLimits.minWindowWidth = customWindowLimits.minWindowWidth;
    }
    if (systemSizeLimits.minWindowHeight <= customWindowLimits.minWindowHeight &&
      customWindowLimits.minWindowHeight <= systemSizeLimits.maxWindowHeight) {
      newSizeLimits.minWindowHeight = customWindowLimits.minWindowHeight;
    }

    if (systemSizeLimits.minWindowHeight > customWindowLimits.minWindowHeight &&
      systemSizeLimits.minWindowHeight > customWindowLimits.maxWindowHeight &&
      customWindowLimits.minWindowHeight > 0 && customWindowLimits.maxWindowHeight > 0) {
      newSizeLimits.minWindowHeight = newSizeLimits.maxWindowHeight = systemSizeLimits.minWindowHeight;
    }
    if (systemSizeLimits.minWindowWidth > customWindowLimits.minWindowWidth &&
      systemSizeLimits.minWindowWidth > customWindowLimits.maxWindowWidth &&
      customWindowLimits.minWindowWidth > 0 && customWindowLimits.maxWindowWidth > 0) {
      newSizeLimits.minWindowWidth = newSizeLimits.maxWindowWidth = systemSizeLimits.minWindowWidth;
    }

    // calcuate new limit ratio
    newSizeLimits.maxWindowRatio = newSizeLimits.maxWindowWidth / newSizeLimits.minWindowHeight;
    newSizeLimits.minWindowRatio = newSizeLimits.minWindowWidth / newSizeLimits.maxWindowHeight;
    if (newSizeLimits.minWindowRatio <= customWindowLimits.maxWindowRatio &&
      customWindowLimits.maxWindowRatio <= newSizeLimits.maxWindowRatio) {
      newSizeLimits.maxWindowRatio = customWindowLimits.maxWindowRatio;
    }
    if (newSizeLimits.minWindowRatio <= customWindowLimits.minWindowRatio &&
      customWindowLimits.minWindowRatio <= newSizeLimits.maxWindowRatio) {
      newSizeLimits.minWindowRatio = customWindowLimits.minWindowRatio;
    }

    // recalculate limit size by new ratio
    newSizeLimits.maxWindowWidth = Math.min(
      newSizeLimits.maxWindowHeight * newSizeLimits.maxWindowRatio, newSizeLimits.maxWindowWidth);
    newSizeLimits.minWindowWidth = Math.max(
      newSizeLimits.minWindowHeight * newSizeLimits.minWindowRatio, newSizeLimits.minWindowWidth);
    newSizeLimits.maxWindowHeight = Math.min(
      newSizeLimits.maxWindowWidth / newSizeLimits.minWindowRatio, newSizeLimits.maxWindowHeight);
    newSizeLimits.minWindowHeight = Math.max(
      newSizeLimits.minWindowWidth / newSizeLimits.maxWindowRatio, newSizeLimits.minWindowHeight);
    // 最小宽度小于屏幕宽度80%的会被限制到悬浮窗样式
    if (newSizeLimits.minWindowWidth == newSizeLimits.maxWindowWidth &&
      newSizeLimits.minWindowHeight == newSizeLimits.maxWindowHeight) {
      defaultWidth = newSizeLimits.minWindowWidth;
      defaultHeight = newSizeLimits.minWindowHeight;
      result.width = defaultWidth;
      result.height = defaultHeight;
      return result;
    }

    if (defaultWidth < newSizeLimits.minWindowWidth || defaultWidth > newSizeLimits.maxWindowWidth) {
      defaultWidth = defaultWidth < newSizeLimits.minWindowWidth ?
      newSizeLimits.minWindowWidth : newSizeLimits.maxWindowWidth;
    }
    if (defaultHeight < newSizeLimits.minWindowHeight || defaultHeight > newSizeLimits.maxWindowHeight) {
      defaultHeight = defaultHeight < newSizeLimits.minWindowHeight ?
      newSizeLimits.minWindowHeight : newSizeLimits.maxWindowHeight;
    }

    const ratio: number = SCBSceneSessionManager.getInstance().getAspectRatioFromPreference(querykey);
    if (newSizeLimits.minWindowRatio <= ratio && ratio <= newSizeLimits.maxWindowRatio) {
      if (scbSceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
        let limits = newSizeLimits;
        limits.minWindowWidth = newSizeLimits.minWindowWidth - 2 * FRAME_WIDTH;
        limits.minWindowHeight = newSizeLimits.minWindowHeight - FRAME_WIDTH - TITLE_HEIGHT;
        const ret = this.fixSizeByRatio(defaultWidth - 2 * FRAME_WIDTH,
          defaultHeight - FRAME_WIDTH - TITLE_HEIGHT, ratio, limits);
        defaultWidth = ret.width + 2 * FRAME_WIDTH;
        defaultHeight = ret.height + FRAME_WIDTH + TITLE_HEIGHT;
        this.log.showDebug(`calcWindowSizeByLimits size [${defaultWidth}, ${defaultHeight}], ratio: ${ratio}`);
        result.width = defaultWidth;
        result.height = defaultHeight;
        return result;
      }
    }

    let curRatio = defaultWidth / defaultHeight;
    if (newSizeLimits.minWindowRatio <= curRatio && curRatio <= newSizeLimits.maxWindowRatio) {
      result.width = defaultWidth;
      result.height = defaultHeight;
      return result;
    }

    curRatio = curRatio < newSizeLimits.minWindowRatio ? newSizeLimits.minWindowRatio : newSizeLimits.maxWindowRatio;
    if (newSizeLimits.maxWindowWidth === newSizeLimits.minWindowWidth) {
      defaultHeight = defaultWidth / curRatio;
      result.width = defaultWidth;
      result.height = defaultHeight;
      return result;
    }
    if (newSizeLimits.maxWindowHeight == newSizeLimits.minWindowHeight) {
      defaultWidth = defaultHeight * curRatio;
      result.width = defaultWidth;
      result.height = defaultHeight;
      return result;
    }
    let screenInfo = this.getRealScreenInfo(scbSceneSession.sceneInfo.windowTop);
    let tempDefaultHeight = defaultWidth / curRatio;
    if (tempDefaultHeight > px2vp(screenInfo.screenHeightLimit)) {
      defaultWidth = defaultHeight * curRatio;
    } else {
      defaultHeight = defaultWidth / curRatio;
    }
    result.width = defaultWidth;
    result.height = defaultHeight;
    return result;
  }

  private fixSizeByRatio(width: number, height: number, ratio: number, limits: WindowSizeLimits): WindowSizeResult {
    if (ratio === 0 || Number.isNaN(ratio)) {
      return { width, height };
    }
    if (width > height * ratio) {
      width = height * ratio;
      if (width < limits.minWindowWidth) {
        width = limits.minWindowWidth;
        height = width / ratio;
      }
      return { width, height };
    } else {
      height = width / ratio;
      if (height < limits.minWindowHeight) {
        height = limits.minWindowHeight;
        width = height * ratio;
      }
      return { width, height };
    }
  }

  private scbVp2RealVpWithDpiRatio(value: number, dpiRatio: number): number {
    if (dpiRatio > 0) {
      return vp2px(value) / dpiRatio;
    } else {
      return value;
    }
  }

  private realVp2ScbVpWithDpiRatio(value: number, dpiRatio: number): number {
    if (dpiRatio > 0) {
      return px2vp(value * dpiRatio);
    } else {
      return value;
    }
  }

  /**
   * hopper启动默认尺寸规格：
   * width  = 长边的60%
   * height = 长边的40%
   * @returns
   */
  private getDefaultWindowSizeForFoldMachine(scbSceneSession: SCBSceneSession, windowWidth: number,
    windowHeight: number): WindowSizeResult {
    let result: WindowSizeResult = new WindowSizeResult();
    const shortSideVp: number = px2vp(Math.min(this.screenProperty.width, this.screenProperty.height));

    if (windowHeight) {
      result.height = px2vp(windowHeight);
    } else {
      result.height = shortSideVp * ViewModelConstant.FOLD_HEIGHT_DEFAULT_RATIO;
    }
    if (windowWidth) {
      result.width = px2vp(windowWidth);
    } else {
      result.width = result.height * ViewModelConstant.FOLD_WIDTH_HEIGHT_RATIO;
    }
    this.log.showInfo(`getDefaultWindowSizeForFoldmachine result: ${JSON.stringify(result)}`);
    return result;
  }

  /**
   * 判断窗口数量是否达到上限: 整机512, 单应用128.
   * @param sceneInfo
   * @returns boolean, true:继续创建窗口 false:达到单进程vsync链接数上限不再继续创建
   */
  private shouldCreateSessionWhenReachMaxSessionNum(sceneInfo: SCBSceneInfo): boolean {
    const sameBundleFunc = (item: SCBSceneSession) => sceneInfo.isSameBundleWithMultiApp(item?.sceneInfo);
    const targetSessionCountAndOldestSession = this.getTargetContainerSessionCountAndOldestTarget(sameBundleFunc);
    if (targetSessionCountAndOldestSession[0] >= this.MAX_VSYNC_CONNECTION_LIMIT_ONE_APP) {
      this.log.showWarn('isReachMaxSessionNum: app(%{public}s) session num is over vsyncConnection limite %{public}d',
        sceneInfo.bundleName, this.MAX_VSYNC_CONNECTION_LIMIT_ONE_APP);
      return false;
    }
    if (targetSessionCountAndOldestSession[0] >= this.MAX_SESSION_LIMIT_ONE_APP) {
      this.log.showWarn('isReachMaxSessionNum: app(%{public}s) session num is over %{public}d', sceneInfo.bundleName,
        this.MAX_SESSION_LIMIT_ONE_APP);
      const oldestContainerSession: SCBSceneContainerSession | null = targetSessionCountAndOldestSession[1];
      this.closeOldestSceneSession(oldestContainerSession as SCBSceneContainerSession, sameBundleFunc);
    }

    const totalLen = this.containerSessionList.length + this.containerSessionListNotShowRecent.length;
    if (totalLen >= ViewModelConstant.MAX_SESSION_LIMIT_ALL_APP) {
      this.log.showWarn('isReachMaxSessionNum: all session num is over %{public}d',
        ViewModelConstant.MAX_SESSION_LIMIT_ALL_APP);
      let oldestContainerSession = this.getOldestContainerSession(this.containerSessionList[0],
        this.containerSessionListNotShowRecent[0]);
      this.closeOldestContainerSession(oldestContainerSession as SCBSceneContainerSession);
    }
    return true;
  }

  private closeOldestSceneSession(oldestContainerSession: SCBSceneContainerSession, filterFunction: Function): void {
    let oldestSession: SCBSceneSession;
    if (filterFunction(oldestContainerSession?.primarySession)) {
      oldestSession = oldestContainerSession?.primarySession as SCBSceneSession;
    } else {
      oldestSession = oldestContainerSession?.secondarySession as SCBSceneSession;
    }
    if (oldestSession.isInSplit()) {
      oldestSession.needDestructedInSplit = true;
    }
    this.log.showWarn('Close oldest scene session, persistentId:%{public}d', oldestSession.sceneInfo.persistentId);
    SCBSceneSessionManager.getInstance().close(oldestSession.sceneInfo.screenId, oldestSession.sceneInfo.persistentId);
  }

  private closeOldestContainerSession(containerSession: SCBSceneContainerSession): void {
    if (containerSession.primarySession) {
      if (containerSession.primarySession.isInSplit()) {
        containerSession.primarySession.needDestructedInSplit = true;
      }
      this.log.showWarn('Close oldest container session, primarySession persistentId:%{public}d',
        containerSession.primarySession.sceneInfo.persistentId);
      SCBSceneSessionManager.getInstance().close(containerSession.primarySession.sceneInfo.screenId,
        containerSession.primarySession.sceneInfo.persistentId);
    }
    if (containerSession.secondarySession) {
      if (containerSession.secondarySession.isInSplit()) {
        containerSession.secondarySession.needDestructedInSplit = true;
      }
      this.log.showWarn('Close oldest container session, secondarySession persistentId:%{public}d',
        containerSession.secondarySession.sceneInfo.persistentId);
      SCBSceneSessionManager.getInstance().close(containerSession.secondarySession.sceneInfo.screenId,
        containerSession.secondarySession.sceneInfo.persistentId);
    }
  }

  private getTargetContainerSessionCountAndOldestTarget(filterFunction: Function):
    [number, SCBSceneContainerSession | null] {
    let oldestContainerSession: SCBSceneContainerSession | null = null;
    let containerSessionCount = 0;

    let targetCountAndFirstTarget = this.containerSessionList.getTargetSessionCountAndFirstContainer(filterFunction);
    containerSessionCount += targetCountAndFirstTarget[0];
    oldestContainerSession = this.getOldestContainerSession(oldestContainerSession, targetCountAndFirstTarget[1]);

    targetCountAndFirstTarget = this.containerSessionListNotShowRecent.getTargetSessionCountAndFirstContainer(
      filterFunction);
    containerSessionCount += targetCountAndFirstTarget[0];
    oldestContainerSession = this.getOldestContainerSession(oldestContainerSession, targetCountAndFirstTarget[1]);
    return [containerSessionCount, oldestContainerSession];
  }

  private getOldestContainerSession(prev: SCBSceneContainerSession | null, cur: SCBSceneContainerSession | null):
  SCBSceneContainerSession | null {
    if (prev && cur) {
      return prev.getLastUsedTimestamp() < cur.getLastUsedTimestamp() ? prev : cur;
    }
    return prev ?? cur;
  }

  private getFromSceneSession(fromInfo: SCBSceneInfo): SCBSceneSession | null {
    const sceneSession = this.getSceneSessionFromOtherScreen(fromInfo);
    if (sceneSession !== undefined) {
      this.log.showInfo('[SCBMain]getFromSceneSession getSceneSessionFromOtherScreen success.');
      return sceneSession;
    }
    return this.getSceneSessionByPersistentId(fromInfo.persistentId);
  }

  private getSceneSessionFromOtherScreen(sceneInfo: SCBSceneInfo): SCBSceneSession | undefined {
    this.log.showInfo('[SCBMain] find sceneSession from other screen');
    const sceneSession: SCBSceneSession | undefined =
      SCBSceneSessionManager.getInstance().popSceneFromOtherScreen(sceneInfo, false, false);
    if (sceneSession !== undefined) {
      this.log.showInfo(`[SCBMain] find sceneSession in screen with id: ${sceneSession.sceneInfo.screenId}`);
      if (!sceneSession.isAvailable) {
        this.log.showError(`[SCBMain] sceneSession is unavailable.`);
        return undefined;
      }
      return sceneSession;
    }
    return undefined;
  }

  private getSceneSessionByPersistentId(persistentId: number): SCBSceneSession | null {
    for (let i = 0; i < this.containerSessionList.length; ++i) {
      const primarySession = this.containerSessionList[i].primarySession;
      const secondarySession = this.containerSessionList[i].secondarySession;
      if (primarySession && primarySession.session.persistentId === persistentId) {
        return primarySession;
      }
      if (secondarySession && secondarySession.session.persistentId === persistentId) {
        return secondarySession;
      }
    }

    for (let i = 0; i < this.containerSessionListNotShowRecent.length; ++i) {
      const primarySession = this.containerSessionListNotShowRecent[i].primarySession;
      const secondarySession = this.containerSessionListNotShowRecent[i].secondarySession;
      if (primarySession && primarySession.session.persistentId === persistentId) {
        return primarySession;
      }
      if (secondarySession && secondarySession.session.persistentId === persistentId) {
        return secondarySession;
      }
    }
    let sceneSession = SCBSceneSessionManager.getInstance()
      .getSpecialContainerSessionList()
      .getSceneSessionByPersistentId(persistentId);
    if (sceneSession) {
      this.log.showInfo(`[SCBMain] getSceneSessionByPersistentId from SpecialContainerSessionList id: ${persistentId}`);
      return sceneSession;
    }
    return null;
  }

  private getSceneSession(sceneInfo: SCBSceneInfo, isFindOtherScreen: boolean = false): SCBSceneSession | null {
    const containerListLen = this.containerSessionList.length;
    for (let i = containerListLen - 1; i >= 0; i--) {
      let primarySession = this.containerSessionList[i].primarySession;
      let secondarySession = this.containerSessionList[i].secondarySession;
      if (primarySession && primarySession.sceneInfo.equalTo(sceneInfo)) {
        return primarySession;
      }
      if (secondarySession && secondarySession.sceneInfo.equalTo(sceneInfo)) {
        return secondarySession;
      }
    }

    const containerListLenNotShowRecent = this.containerSessionListNotShowRecent.length;
    for (let i = containerListLenNotShowRecent - 1; i >= 0; i--) {
      const primarySession = this.containerSessionListNotShowRecent[i].primarySession;
      const secondarySession = this.containerSessionListNotShowRecent[i].secondarySession;
      if (primarySession && primarySession.sceneInfo.equalTo(sceneInfo) &&
        (!isFindOtherScreen || primarySession.sessionData.sceneSessionEverShown)) {
        return primarySession;
      }
      if (secondarySession && secondarySession.sceneInfo.equalTo(sceneInfo) &&
        (!isFindOtherScreen || secondarySession.sessionData.sceneSessionEverShown)) {
        return secondarySession;
      }
    }
    return null;
  }

  private exitRecentView(needAnim: boolean = true): void {
    this.panelProxy.exitRecentView(needAnim);
  }

  private dealInSplit(persistentId?: number): void {
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (!sceneContainerSession) {
      return;
    }
    this.log.showInfo('primarySession persistentId ' + sceneContainerSession.primarySession?.session.persistentId +
      ' secondarySession persistentId ' + sceneContainerSession.secondarySession?.session.persistentId);
    const needPairScene = persistentId === sceneContainerSession.primarySession?.session.persistentId ?
    sceneContainerSession.primarySession : sceneContainerSession.secondarySession;
    if (needPairScene && needPairScene.sceneInfo.windowMode !== SCBSceneMode.PRIMARY &&
      needPairScene.sceneInfo.windowMode !== SCBSceneMode.SECONDARY) {
      this.pairSplit(needPairScene);
      this.panelProxy.updateScenePanelState(ScenePanelState.HOME);
    }
  }

  private pairSplit(sceneSession: SCBSceneSession | null) {
    this.log.showInfo('pairSplit ' + sceneSession?.sceneInfo.bundleName)
    let parm = new ExitSplitParam();
    parm.needExitSplitRecent = false;
    this.exitSplitView(sceneSession?.session.persistentId, parm);
    const sceneContainerSession = this.getSceneContainerSessionWithPersistentId(sceneSession?.session.persistentId);
    if (sceneContainerSession !== null) {
      this.removeAllScreenSceneContainerSession(sceneContainerSession);
      this.resizeWhenPairSplitIfNeed(sceneContainerSession);
      this.log.showInfo('start scene split remove old container session: ' + sceneContainerSession.containerId);
    }
    const activeSceneContainerSession = this.getTopActiveSplitSceneContainerSession();
    const isActive = sceneSession?.isActive;
    if (activeSceneContainerSession) {
      this.panelProxy.setIsPairSplit(false);
      activeSceneContainerSession.isPairSplitAnimating = true;
      activeSceneContainerSession.addSceneSession(sceneSession); // need to change
      activeSceneContainerSession.updateSubWindowBinding(this.screenProperty.screenId);
      activeSceneContainerSession.primarySession?.setUIFirstSwitch(
        sceneSessionManager.RSUIFirstSwitch.FORCE_DISABLE_NONFOCUS);
      activeSceneContainerSession.secondarySession?.setUIFirstSwitch(
        sceneSessionManager.RSUIFirstSwitch.FORCE_DISABLE_NONFOCUS);
      this.log.showInfo('start scene split after add active sceneSession container: ' +
      activeSceneContainerSession.containerId);
      AppStorage.setOrCreate('isSplitAnimating', true);
      if (sceneSession) {
        sceneSession.isPairSplitScene = true;
        sceneSession.isHideShadow = false;
        const yOffset = this.panelProxy.getScroller().currentOffset()?.yOffset;
        if (yOffset) {
          sceneSession.translateY -= yOffset;
        }
        activeSceneContainerSession.isSplitPrimaryMode() ?
        this.doPairSplitSecondary(sceneSession, activeSceneContainerSession) :
        this.doPairSplitPrimary(sceneSession, activeSceneContainerSession);
        sceneSession.sessionData.isLastSplit = false;
      }
      this.initSplitWidthLimits(activeSceneContainerSession);
      this.resetWindowEffect(activeSceneContainerSession);
      this.doSplitSceneRecover();
      if (activeSceneContainerSession.primarySession?.isTopmost ||
        activeSceneContainerSession.secondarySession?.isTopmost) {
        this.containerSessionList.sortByTopmost();
      }
    }
    if (!isActive) {
      activeSceneContainerSession?.secondarySession?.requestSessionActivation();
    }
    this.refreshZOrder();
    this.setRecentDataList();
    this.enterFullSceneOrHomeView(ScenePanelState.HOME);
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    this.log.showInfo('pair split end. primarySession visibility:' +
      activeSceneContainerSession?.primarySession?.getVisibility() + ', secondarySession visibility:' +
      activeSceneContainerSession?.secondarySession?.getVisibility());
  }

  private doSplitSceneRecover(): void {
    const sceneContainerSession = this.getSceneContainerSessionWithPersistentId(this.pairPersistentId);
    if (sceneContainerSession !== null) {
      sceneContainerSession.primarySession?.recover();
      sceneContainerSession.primarySession?.setUIFirstSwitch(sceneSessionManager.RSUIFirstSwitch.NONE);
      sceneContainerSession.dividerParam.dividerTranslateX = 0;
      sceneContainerSession.dividerParam.dividerTranslateY = 0;
      sceneContainerSession.dividerParam.scaleX = 1;
      sceneContainerSession.dividerParam.scaleY = 1;
      this.pairPersistentId = -1;
      this.panelProxy.setPairPersistentId(this.pairPersistentId);
    }
  }

  private doPairSplitPrimary(sceneSession: SCBSceneSession,
    activeSceneContainerSession: SCBSceneContainerSession): void {
    this.log.showInfo('doSplitPrimary, ' + sceneSession?.currRect.width.getPx() + ', ' +
    sceneSession?.currRect.height.getPx() + ', mode:' + sceneSession.sceneInfo.windowMode);
    SCBFreeWindowsDfx.getInstance().splitStart(sceneSession.sceneInfo?.bundleName, true);
    AppStorage.setOrCreate('isDockMissionsPopupShow', false);
    if (sceneSession.sceneInfo.windowMode == SCBSceneMode.FLOATING) {
      SCBSceneHelper.updateLastDpi(sceneSession, this.screenDpiDensity);
    }
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING && !sceneSession.isMaximizeFloating &&
      !sceneSession.isLastSplit) {
      sceneSession.saveLastRect();
    }
    if (sceneSession.sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      sceneSession.floatBorderRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    }
    sceneSession.needRenderSnapShotAnimConfig.animActionId = SCBSessionEventId.EVENT_SPLIT_PRIMARY;
    sceneAnimationManager.setFreezeImmediately(sceneSession, true);
    sceneSession.sessionData.lastWindowMode = sceneSession.sceneInfo.windowMode;
    sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
    sceneSession.sessionData.isMaximizeFloating = false;
    this.doSplitPrimaryAnimate(sceneSession, activeSceneContainerSession);
    sceneAnimationManager.setFreezeImmediately(sceneSession, false);
    this.doSpecificSceneAnimateIn(sceneSession, 0);
  }

  private doPairSplitSecondary(sceneSession: SCBSceneSession,
    activeSceneContainerSession: SCBSceneContainerSession): void {
    this.log.showInfo('doSplitSecondary, ' + sceneSession?.currRect.width.getPx() + ', ' +
    sceneSession?.currRect.height.getPx() + ', mode:' + sceneSession.sceneInfo.windowMode);
    SCBFreeWindowsDfx.getInstance().splitStart(sceneSession.sceneInfo?.bundleName, true);
    AppStorage.setOrCreate('isDockMissionsPopupShow', false);
    if (sceneSession.sceneInfo.windowMode == SCBSceneMode.FLOATING) {
      SCBSceneHelper.updateLastDpi(sceneSession, this.screenDpiDensity);
    }
    if (sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING && !sceneSession.isMaximizeFloating &&
      !sceneSession.isLastSplit) {
      sceneSession.saveLastRect();
    }
    if (sceneSession.sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      sceneSession.floatBorderRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    }
    sceneSession.needRenderSnapShotAnimConfig.animActionId = SCBSessionEventId.EVENT_SPLIT_SECONDARY;
    sceneAnimationManager.setFreezeImmediately(sceneSession, true);
    sceneSession.sessionData.lastWindowMode = sceneSession.sceneInfo.windowMode;
    sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
    sceneSession.sessionData.isMaximizeFloating = false;
    this.doSplitSecondaryAnimate(sceneSession, activeSceneContainerSession);
    sceneAnimationManager.setFreezeImmediately(sceneSession, false);
    this.doSpecificSceneAnimateIn(sceneSession, 0);
  }

  private exitSplitForPairSplit(persistentId?: number, isEnterPair: boolean = false): void {
    this.log.showInfo('exitSplitForPairSplit. persistentId: ' + persistentId);
    const index = this.containerSessionList.findIndex((item) => {
      return item.primarySession?.session.persistentId === persistentId ||
        item.secondarySession?.session.persistentId === persistentId;
    });
    let currContainerSession = this.containerSessionList[index];
    if (!this.canDoExitSplitView(persistentId, index, currContainerSession)) {
      return;
    }
    let primarySession = currContainerSession.primarySession;
    let secondarySession = currContainerSession.secondarySession;
    if (!(primarySession && secondarySession)) {
      return;
    }
    this.pcExitSplitCommand = MonitorExitSplitName.REASSEMBLY_SPLIT;
    if (isEnterPair) {
      this.doExitSplitView(index, currContainerSession, true, isEnterPair);
      primarySession.sessionData.isLastSplit = false;
      secondarySession.sessionData.isLastSplit = false;
      if (primarySession?.session.persistentId === persistentId) {
        this.pairPersistentId = secondarySession ? secondarySession.session.persistentId : -1;
        primarySession.sessionData.isLastSplit = true;
        primarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      } else {
        this.pairPersistentId = primarySession ? primarySession.session.persistentId : -1;
        secondarySession.sessionData.isLastSplit = true;
        secondarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      }
      this.panelProxy.setPairPersistentId(this.pairPersistentId);
    } else {
      this.doExitSplitView(index, currContainerSession, true);
      primarySession.sessionData.isLastSplit = false;
      secondarySession.sessionData.isLastSplit = false;
      if (primarySession?.session.persistentId === persistentId) {
        secondarySession.sessionData.isNeedUpdateOnSplitRecentView = true;
        secondarySession.sessionData.isLastSplit = true;
        secondarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      } else {
        primarySession.sessionData.isNeedUpdateOnSplitRecentView = true;
        primarySession.sessionData.isLastSplit = true;
        primarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      }
    }
  }

  private canDoExitSplitView(persistentId: number | undefined, index: number,
    container: SCBSceneContainerSession): boolean {
    if (index === -1) {
      this.log.showWarn('Failed to get scene containerSession with session id: ' + persistentId);
      return false;
    }
    if (!container.isSplit) {
      this.log.showInfo('ExitSplitView stop because no split container');
      return false;
    }
    return true;
  }

  private removeAllScreenSceneContainerSession(sceneContainerSession: SCBSceneContainerSession,
    idxMap?: Map<number, number>): void {
    if (!sceneContainerSession) {
      return;
    }
    this.removeSceneContainerSessionNotShowRecent(sceneContainerSession);
    let screenProperty = new SCBScreenProperty();
    for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      screenProperty.screenId = screenSession.session.screenId;
      const index = SCBSessionListManager.getNormalContainerArray(screenProperty).findIndex((item) => {
        return item.containerId === sceneContainerSession.containerId;
      });
      if (index !== -1) {
        if (idxMap && screenProperty.screenId !== this.screenProperty.screenId) {
          idxMap.set(screenProperty.screenId, index);
        }
        this.log.showInfo('Remove scene container session, id: ' + sceneContainerSession.containerId +
          ', screenId: ' + screenSession.session.screenId);
        SCBSessionListManager.getNormalContainerArray(screenProperty).splice(index, 1);
      }
    }
    this.refreshZOrder();
  }

  private createContainerSessionForExitSplit(sceneSession: SCBSceneSession, idxMap: Map<number, number>,
    isContainerShow: boolean = true, raiseToTop?: boolean): SCBSceneContainerSession {
    let containerSessionForExitSplit = new SCBSceneContainerSession(sceneSession, this.screenProperty);
    containerSessionForExitSplit.init();
    containerSessionForExitSplit.isSplit = false;
    if (containerSessionForExitSplit.primarySession) {
      containerSessionForExitSplit.primarySession.isHideShadow = false;
    }
    let screenProperty = new SCBScreenProperty();
    for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      screenProperty.screenId = screenSession.session.screenId;
      let index = idxMap.get(screenProperty.screenId);
      if (index !== undefined && index !== -1) {
        if (isContainerShow) {
          index += raiseToTop ? 1 : 0;
          SCBSessionListManager.getNormalContainerArray(screenProperty)
            .spliceAndInsert(index, 0, containerSessionForExitSplit);
        } else {
          this.addSceneContainerSessionNotShowRecent(containerSessionForExitSplit);
        }
      }
    }
    let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
    sessionChangeInfo.persistentIds.push(sceneSession.sceneInfo.persistentId);
    sessionChangeInfo.curScreenId = this.screenProperty.screenId;
    SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.REFRESH, sessionChangeInfo);
    if (!SCBSceneSessionManager.getInstance().isScreenLocked()) {
      if (sceneSession.isActive) {
        containerSessionForExitSplit.requestActivation(false, ActiveReason.EXIT_SPLIT);
      } else {
        containerSessionForExitSplit.requestActivation(false);
      }
    }

    containerSessionForExitSplit.dividerParam.isSplitRecentPair = false;
    sceneSession.sessionData.isLastSplit = false;
    return containerSessionForExitSplit;
  }

  private updateRecentInfoAfterExitForSplit(newSceneContainerSession: SCBSceneContainerSession,
    currContainerSession: SCBSceneContainerSession,
    primarySession: SCBSceneSession,
    secondarySession: SCBSceneSession | null,
    isEnterPair: boolean = false): void {
    this.log.showInfo(`panelProxy call updateRecentInfoAfterExitForSplit`);
    this.panelProxy.updateRecentInfoAfterExitForSplit(newSceneContainerSession, currContainerSession,
      primarySession, secondarySession, isEnterPair);
  }

  private onExitActiveSplit(): void {
    if (!this.isInPanelState(ScenePanelState.SPLIT)) {
      return;
    }
    const activeSceneContainerSession = this.getTopActiveSplitSceneContainerSession();
    if (activeSceneContainerSession) {
      let param = new ExitSplitParam();
      if (activeSceneContainerSession.primarySession?.sessionData.lastWindowMode === SCBSceneMode.FULLSCREEN) {
        param.exitSplitEvent = SCBSessionEventId.EVENT_MAXIMIZE;
      }
      this.exitSplitView(activeSceneContainerSession.primarySession?.session?.persistentId, param);
    } else {
      this.log.showError('split container does not exist');
      this.exitSplitRecentView();
      this.updateStatusAfterExit(true);
    }
  }

  private exitSplitScreenAndReorder(isShowAboveKeyguard: boolean,
    containerSession: SCBSceneContainerSession | null,
    sceneInfo: SCBSceneInfo): SCBSceneContainerSession | null {
    if (isShowAboveKeyguard && containerSession?.isSplit && sceneInfo.isCalledRightlyByCallerId) {
      this.log.showInfo('[SCBMain]containerSession exit split screen, persistentId: ' + sceneInfo.persistentId);
      this.exitSplitView(sceneInfo.persistentId);
      SCBSceneSessionManager.getInstance().reOrderShowWhenLocked();
      return this.getSceneContainerSessionWithPersistentId(sceneInfo.persistentId);
    }
    return containerSession;
  }

  private getWindowLimits(sceneSession: SCBSceneSession): bundleManager.WindowSize {
    try {
      const windowLimits: ESObject = sceneSessionManager.getWindowLimits(sceneSession.sceneInfo.persistentId);
      const px2vpCoefficient = ViewModelConstant.BASE_DENSITY / this.screenDpiDensity;
      return {
        maxWindowWidth: windowLimits.maxWidth * px2vpCoefficient,
        maxWindowHeight: windowLimits.maxHeight * px2vpCoefficient,
        minWindowWidth: windowLimits.minWidth * px2vpCoefficient,
        minWindowHeight: windowLimits.minHeight * px2vpCoefficient,
        maxWindowRatio: 0,
        minWindowRatio: 0
      }
    } catch (err) {
      this.log.showError(`getWindowlimits error: ${err?.message}`);
    }
    const windowSize = SCBSceneSessionManager.getInstance().getAbilityWindowSize(
      sceneSession.sceneInfo.bundleName + sceneSession.sceneInfo.moduleName + sceneSession.sceneInfo.abilityName);
    return windowSize;
  }

  private initSplitWidthLimits(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession || !sceneContainerSession.primarySession || !sceneContainerSession.secondarySession) {
      this.log.showWarn('initSplitWidthLimits null session');
      return;
    }
    const priWindowLimits = this.getWindowLimits(sceneContainerSession.primarySession);
    const secWindowLimits = this.getWindowLimits(sceneContainerSession.secondarySession);
    if (!priWindowLimits || !secWindowLimits) {
      return;
    }
    const rect = LayoutPolicyHelper.getInstance()
      .getSplitInitialRect(this.screenProperty, sceneContainerSession.dividerParam, true);
    const screenWidthInVp = SCBSystemSceneUtils.getInstance().px2vp(this.uiContext, this.screenProperty.width);
    const halfWidth = (screenWidthInVp - DividerStyle.DIVIDER_WIDTH) / 2;
    const halfHeight = rect.height.getVp();

    sceneContainerSession.dividerParam.setPrimaryMinWidth(Math.max(
      Math.min(priWindowLimits.minWindowWidth, halfWidth), DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_WIDTH));
    sceneContainerSession.dividerParam.setPrimaryMinHeight(Math.max(
      Math.min(priWindowLimits.minWindowHeight, halfHeight), DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_HEIGHT));

    sceneContainerSession.dividerParam.setSecondaryMinWidth(Math.max(
      Math.min(secWindowLimits.minWindowWidth, halfWidth), DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_WIDTH));
    sceneContainerSession.dividerParam.setSecondaryMinHeight(Math.max(
      Math.min(secWindowLimits.minWindowHeight, halfHeight), DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_HEIGHT));
    this.log.showInfo('initSplitWidthLimits primaryMinWidth:' + sceneContainerSession.dividerParam.primary.minWidth +
      ' secondaryMinWidth: ' + sceneContainerSession.dividerParam.secondary.minWidth + ' halfWidth ' + halfWidth);
  }

  private exitSplitRecentView(isAnimateImmediately: boolean = true, isPairSplit: boolean = false): void {
    this.panelProxy.exitSplitRecentView(isAnimateImmediately, isPairSplit);
  }

  private onExitSplitRaiseToTop(sceneSession: SCBSceneSession | null): void {
    SCBSceneSessionManager.getInstance()
      .requestFocus(sceneSession?.session.persistentId, false, FocusChangeReason.SPLIT_SCREEN);
    const containerSession = this.getSceneContainerSessionWithPersistentId(sceneSession?.sceneInfo.persistentId);
    containerSession && this.raiseSceneToTop(containerSession);
  }

  private updateStatusAfterExit(needExitSplitRecent: boolean): void {
    this.setRecentDataList();
    if (needExitSplitRecent) {
      this.enterFullSceneOrHomeView(ScenePanelState.HOME);
    }
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    this.panelProxy.getSysSceneSession().setSessionTouchable(false);
  }

  private resetWindowEffect(containerSession: SCBSceneContainerSession) {
    if (containerSession.primarySession) {
      containerSession.primarySession.floatBorderRadius = 0;
      containerSession.primarySession.shadowConfig.radius = 0;
    }

    if (containerSession.secondarySession) {
      containerSession.secondarySession.floatBorderRadius = 0;
      containerSession.secondarySession.shadowConfig.radius = 0;
    }
    this.resetWindowStroke(containerSession);
  }

  private resetWindowStroke(sceneContainerSession: SCBSceneContainerSession): void {
    sceneContainerSession.primarySession?.resetWindowStrokeConfig();
    sceneContainerSession.secondarySession?.resetWindowStrokeConfig();
  }

  private moveSessionToTargetScreen(persistentId: number | undefined, displayId: number,
    sceneSession: SCBSceneSession | null): void {
    if (displayId !== INVALID_SCREEN_ID && persistentId !== undefined && sceneSession) {
      let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
      sessionChangeInfo.persistentIds.push(persistentId);
      sessionChangeInfo.targetScreenId = displayId;
      sessionChangeInfo.curScreenId = this.screenProperty.screenId;
      let sessionRectChangeInfo: SessionRectChangeInfo = new SessionRectChangeInfo();
      sessionRectChangeInfo.newRect = sceneSession.lastRect.transfer2SessionRect();
      sessionRectChangeInfo.reason = sceneSessionManager.SessionSizeChangeReason.RECOVER;
      sessionChangeInfo.sessionRectChangeMap.set(persistentId, sessionRectChangeInfo);
      SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.MOVE_TO_TARGET_DISPLAY,
        sessionChangeInfo);
    }
  }

  private setSpecSceneOpacity(specificScene: SCBSpecificSession, opacity: number): void {
    this.log.showInfo(`setSpecSceneOpacity persistentId: ${specificScene.session.persistentId}, opacity: ${opacity}`);
    specificScene!.opacity = opacity;
  }

  private splitRequestActivation(sceneInfo: SCBSceneInfo): void {
    let sceneSession: SCBSceneSession | null = this.requestSceneSession(sceneInfo);
    if (sceneSession == null) {
      this.log.showError('Failed to request scene session!');
      return;
    }
    let sceneContainerSession: SCBSceneContainerSession | null =
      this.getSceneContainerSessionWithPersistentId(sceneSession.session.persistentId);
    if (sceneContainerSession == null) {
      this.log.showError('sceneContainerSession is null!');
      return;
    }
    if (sceneContainerSession.isSplit) {
      sceneContainerSession.updateTerminateStatus(false);
      sceneContainerSession.isDisappearing = false;
      sceneContainerSession.sessionData.pendingRemove = false;
      sceneContainerSession.notifyInteractiveStateChange(true);
      if (sceneInfo.persistentId === sceneContainerSession.primarySession?.sceneInfo.persistentId) {
        sceneContainerSession.secondarySession?.
        requestSessionActivation(sceneContainerSession.secondarySession?.isActive ? false : this.isNewWant);
        sceneContainerSession.primarySession.requestSessionActivation(this.isNewWant);
      } else {
        sceneContainerSession.primarySession?.
        requestSessionActivation(sceneContainerSession.primarySession?.isActive ? false : this.isNewWant);
        sceneContainerSession.secondarySession?.requestSessionActivation(this.isNewWant);
      }
    } else {
      sceneContainerSession.requestActivation(sceneSession.isNewWant);
    }
  }

  private doSplitPrimaryAnimate(sceneSession: SCBSceneSession,
    activeSceneContainerSession: SCBSceneContainerSession): void {
    sceneAnimationManager.initAnimatePara(sceneSession, LayoutPolicyHelper.getInstance()
      .getSplitInitialRect(this.screenProperty, activeSceneContainerSession.dividerParam, true));
    sceneSession.setGravity(sceneSessionManager.Gravity.RESIZE);
    this.getUiContext()?.animateToImmediately({
      duration: 0,
      onFinish: () => {
        sceneSession.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
        if (sceneSession?.isPairSplitScene) {
          sceneSession.isPairSplitScene = false;
          AppStorage.setOrCreate('isSplitAnimating', false);
        }
        this.panelProxy.exitSplitRecentViewIfNotShowRecent();
        activeSceneContainerSession.isPairSplitAnimating = false;
        activeSceneContainerSession.needTrackSplitState.setState(SplitState.UNDEFINED);
        SCBFreeWindowsDfx.getInstance().splitEnd(true);
      }
    }, () => {
      sceneSession.floatBorderRadius = 0;
      sceneSession.initSceneState();
      activeSceneContainerSession.primarySession!.translateY = 0;
      activeSceneContainerSession.dividerParam!.dividerTranslateY = 0;
    });
    this.setCommonAnimate(sceneSession);
  }

  private doSplitSecondaryAnimate(sceneSession: SCBSceneSession,
    activeSceneContainerSession: SCBSceneContainerSession): void {
    sceneAnimationManager.initAnimatePara(sceneSession, LayoutPolicyHelper.getInstance()
      .getSplitInitialRect(this.screenProperty, activeSceneContainerSession.dividerParam, false));
    sceneSession.setGravity(sceneSessionManager.Gravity.RESIZE);
    this.getUiContext()?.animateToImmediately({
      duration: 0,
      onFinish: () => {
        sceneSession.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
        if (sceneSession?.isPairSplitScene) {
          sceneSession.isPairSplitScene = false;
          AppStorage.setOrCreate('isSplitAnimating', false);
        }
        this.panelProxy.exitSplitRecentViewIfNotShowRecent();
        activeSceneContainerSession.isPairSplitAnimating = false;
        activeSceneContainerSession.needTrackSplitState.setState(SplitState.UNDEFINED);
        SCBFreeWindowsDfx.getInstance().splitEnd(true);
      }
    }, () => {
      sceneSession.floatBorderRadius = 0;
      sceneSession.initSceneState();
      activeSceneContainerSession.primarySession!.translateY = 0;
      activeSceneContainerSession.dividerParam!.dividerTranslateY = 0;
    });
    this.setCommonAnimate(sceneSession);
  }

  private setCommonAnimate(sceneSession: SCBSceneSession) {
    sceneSession.needRenderSnapShotAnimConfig.animVisible = true;
    sceneSession.needRenderSnapShotAnimConfig.animSceneAlpha = 1;
    this.getUiContext()?.animateTo({
      curve: Curve.Friction,
      duration: 200,
      delay: 50,
      onFinish: () => {
        sceneSession.needRenderSnapShotAnimConfig.animVisible = false;
        sceneSession.needRenderSnapShotAnimConfig.animSnapshot = undefined;
        sceneSession.needRenderSnapShotAnimConfig.animActionId = 0;
      }
    }, () => {
      sceneSession.needRenderSnapShotAnimConfig.animSceneAlpha = 0;
      this.updateSubSessionWhenRelativeToParent(sceneSession);
    });
  }

  private doSpecificSceneAnimateIn(primarySession: SCBSceneSession, delayAnimateMs: number): void {
    let specificSceneList: SCBSpecificSession[] = [];
    let dialogSceneList = primarySession.dialogSessionList;
    let subSceneList = primarySession.subSessionList;
    specificSceneList.push(...dialogSceneList as (SCBSpecificSession)[]);
    if (subSceneList !== null) {
      SCBSceneHelper.traverseSubList(subSceneList, specificSceneList);
    }
    const sceneWidth = primarySession.currRect.width.getVp();
    const sceneHeight = primarySession.currRect.height.getVp();
    if (specificSceneList.length > 0) {
      this.log.showInfo(`doSpecificSceneAnimateIn specificSceneList.length: ${specificSceneList.length}`);
      for (let i = 0; i < specificSceneList.length; i++) {
        const specificScene = specificSceneList[i];
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          specificScene.scaleX = 1.0;
        })
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          specificScene.scaleY = 1.0;
        })
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          specificScene.translateX = 0;
          specificScene.translateY = 0;
        })
        this.getUiContext()?.animateTo({
          duration: 0,
        }, () => {
          this.setSpecSceneOpacity(specificScene, 1.0);
        })
      }
    }
  }

  private startSceneFromRecentTransition(sceneContainerSession: SCBSceneContainerSession,
    extraInfo?: ExecuteCallbackExtraInfo): void {
    const sceneInfo = sceneContainerSession?.primarySession?.sceneInfo;
    let transitionController: SCBTransitionController | null = null;
    if (sceneInfo) {
      transitionController = SCBTransitionManager.getInstance().findTransitionController(
        sceneInfo.bundleName, () => {
        const appData = PageDesktopModel.getInstance().getCloseAppData(sceneInfo.bundleName, sceneInfo.abilityName,
          null, null, null, sceneInfo.appIndex, null, sceneInfo?.appInstanceKey);
        appData.screenId = this.screenProperty.screenId;
        return appData;
      });
    }
    if (!transitionController) {
      this.log.showInfo('start scene controller is null first');
      transitionController = PageDesktopModel.getInstance().getDefaultTransitionController(
        this.getAppInfoFromDock(sceneContainerSession, extraInfo));
    }
    this.log.showInfo(`start scene controller: ${transitionController?.appData.bundleName}`);
    performanceMonitor.begin(PageDesktopModel.getInstance().getSceneLaunchType(sceneContainerSession.companionIconInfo),
      performanceMonitor.ActionType.LAST_UP, sceneContainerSession.companionIconInfo?.bundleName);
    this.onSceneContainerTransitionIn(sceneContainerSession, transitionController, undefined, false, false, extraInfo);
  }

  private handleProactiveExitSplit(param: ExitSplitParam, primarySession: SCBSceneSession | null,
    secondarySession: SCBSceneSession | null) {
    if (!primarySession) {
      return;
    }
    const containerSession = this.getSceneContainerSessionWithPersistentId(
      primarySession.sceneInfo.persistentId);
    switch (param.exitSplitEvent) {
      case SCBSessionEventId.EVENT_MAXIMIZE:
        primarySession.maximize();
        primarySession.sessionData.dragDividerToMaximize = false;
        AppStorage.setOrCreate('isSplitAnimating', false);
        break;
      case SCBSessionEventId.EVENT_MAXIMIZE_FULLSCREEN:
        primarySession.maximizeFullScreen(true);
        primarySession.sessionData.dragDividerToMaximize = false;
        AppStorage.setOrCreate('isSplitAnimating', false);
        break;
      case SCBSessionEventId.EVENT_MINIMIZE:
        primarySession.sessionData.isLastSplit = true;
        primarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
        containerSession && this.onSceneMinimize(containerSession);
        break;
      case SCBSessionEventId.EVENT_CLOSE:
        const extraInfo: ExecuteCallbackExtraInfo = {
          isSplitClose: true
        };
        this.onCloseSceneInner(primarySession.sceneInfo.persistentId, 0, false, true, extraInfo);
        break;
      case SCBSessionEventId.EVENT_RECOVER:
        primarySession?.recover();
        break;
      default:
        break;
    }
    this.onExitSplitRaiseToTop(param.needRaise ? primarySession : secondarySession);
  }

  private handlePassiveExitSplit(param: ExitSplitParam, primarySession: SCBSceneSession | null,
    secondarySession: SCBSceneSession | null) {
    if (secondarySession?.sessionData.lastWindowMode === SCBSceneMode.FULLSCREEN) {
      secondarySession?.maximize()
    } else {
      secondarySession?.recover();
    }
  }

  private handleContainerSessionForExitSplit(containerSession: SCBSceneContainerSession, sceneSession: SCBSceneSession,
    idxMap: Map<number, number>, isContainerShow: boolean = true): SCBSceneContainerSession {
    containerSession.isSplit = false;
    containerSession.secondarySession = null;
    containerSession.init();
    sceneSession.isHideShadow = false;
    sceneSession.sessionData.isLastSplit = false;
    let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
    sessionChangeInfo.persistentIds.push(sceneSession.sceneInfo.persistentId);
    sessionChangeInfo.curScreenId = this.screenProperty.screenId;
    SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.REFRESH, sessionChangeInfo);
    if (!SCBSceneSessionManager.getInstance().isScreenLocked()) {
      if (sceneSession.isActive ) {
        containerSession.requestActivation(false, ActiveReason.EXIT_SPLIT);
      } else {
        containerSession.requestActivation(false);
      }
    }
    containerSession.dividerParam.init();
    containerSession.dividerParam.isSplitRecentPair = false;
    containerSession.dividerParam.isEndSplit = true;
    containerSession.dividerParam.isSplitPrimaryMode = true;
    containerSession.dividerParam.dividerOpacity = 0;
    if (!isContainerShow) {
      let screenProperty = new SCBScreenProperty();
      for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
        screenProperty.screenId = screenSession.session.screenId;
        let index = idxMap.get(screenProperty.screenId);
        if (index !== undefined && index !== -1) {
          this.removeAllScreenSceneContainerSession(containerSession, idxMap);
          SCBSessionListManager.getNormalContainerArray(screenProperty)
            .spliceAndInsert(index, 0, containerSession);
        }
      }
    }
    return containerSession;
  }

  private onRecoverOrMaximizeCompatibleScene(isMaximize: boolean, persistentId?: number, containerId?: number): void {
    this.log.showInfo(`[SCBMain]onRecoverOrMaximizeCompatibleScene persistentId: ${persistentId} isMaximize: ${isMaximize}`);
    let containerSession = persistentId ? this.getSceneContainerSessionWithPersistentId(persistentId) :
    this.getSceneContainerSessionWithContainerId(containerId);
    if (!containerSession) {
      this.log.showError(`cannot find containerSession with persistentId:${persistentId}`);
      return;
    }
  }

  private doAnimateOutFromSetParentSession(sceneContainerSession: SCBSceneContainerSession,
    extraInfo?: ExecuteCallbackExtraInfo): void {
    let primarySession = sceneContainerSession?.primarySession;
    if (!primarySession) {
      this.log.showError(`primarySession is null`);
      return;
    }
    let iconRect: RectInfo = new RectInfo();
    const appItem = this.getAppInfoFromDock(sceneContainerSession, extraInfo);
    let hasIcon: boolean = (appItem !== undefined && appItem !== null);
    const context: UIContext = this.getUiContext();
    if (appItem) {
      iconRect = this.getIconRect(appItem);
    }
    const sceneWidth: number = SCBSystemSceneUtils.getInstance().px2vp(context, primarySession.currRect.width.getPx());
    const sceneHeight: number =
      SCBSystemSceneUtils.getInstance().px2vp(context, primarySession.currRect.height.getPx());
    const iconWidth: number = iconRect.right - iconRect.left;
    const iconHeight: number = iconRect.bottom - iconRect.top;
    hasIcon = hasIcon && ((iconWidth !== 0) && (iconHeight !== 0));
    const iconTransAlpha: number = this.APP_ICON_TRANS_ALPHA;
    const sceneTransAlpha: number = this.SCENE_TRAN_ALPHA;
    const sceneInitSize: number = (1.0 + 0.5 * (1.0 - sceneTransAlpha) / iconTransAlpha) * iconWidth;
    let minSceneSize: number = Math.min(sceneWidth, sceneHeight);
    if (SCBSceneHelper.nearEqual(minSceneSize, 0)) {
      minSceneSize = 1;
    }
    const sceneEndScale: number = sceneInitSize / minSceneSize;
    this.doSpecificSceneAnimateOut(primarySession, iconRect, hasIcon, sceneEndScale);
  }

  private onStartSceneFromPip(persistentId: number): void {
    this.log.showInfo(`startSceneFromPip, persistentId: ${persistentId}`);
    let sceneContainerSession = this.getSceneContainerSessionWithPersistentId(persistentId);
    if (sceneContainerSession == null) {
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
      this.log.showError('Failed to get sceneContainerSession');
      return;
    }
    if (this.isInPanelState(ScenePanelState.RECENT)) {
      // 历史任务还原场景
      this.startSceneFromRecent(persistentId, sceneContainerSession.containerId);
      return;
    }
    if (sceneContainerSession.primarySession === null) {
      this.log.showError('Failed to get primarySession');
      return;
    }
    let toInfo = sceneContainerSession.primarySession.sceneInfo;
    if (sceneContainerSession.secondarySession) {
      toInfo = sceneContainerSession.secondarySession.sceneInfo.persistentId == persistentId ?
      sceneContainerSession.secondarySession.sceneInfo : sceneContainerSession.primarySession.sceneInfo;
    }
    if (SCBSceneSessionManager.getInstance().isStartingSceneFromPiP && sceneContainerSession.isMidScene) {
      sceneContainerSession.midSceneMap.forEach(value => {
        if (value.sceneInfo.persistentId == persistentId) {
          toInfo = value.sceneInfo;
        }
      })
    }
    let currentSession = this.containerSessionList.getTopActiveSession();
    if (currentSession == null || this.isInPanelState(ScenePanelState.SPLIT)) {
      // 由桌面还原场景
      this.startSceneFromOther(toInfo);
      return;
    }
    if (sceneContainerSession == currentSession) {
      this.log.showInfo('Restore from current app');
      // 本应用还原场景
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
      return;
    }
    if (currentSession.primarySession) {
      let fromInfo = currentSession.primarySession.sceneInfo;
      // 其他应用还原场景
      this.startSceneTransition(toInfo, fromInfo);
      return;
    }
  }

  //  如果是未启动的窗口，且找到的窗口在其他屏幕，则将隐藏启动的窗口迁移到当前屏幕
  private moveHiddenSessionToAnotherScreen(sceneSession: SCBSceneSession): void {
    if (!sceneSession.sessionData.sceneSessionEverShown &&
      sceneSession.sceneInfo.screenId !== this.screenProperty.screenId) {
      let containerSession = SCBSceneSessionManager.getInstance()
        .getContainerSessionListNotShowRecent(sceneSession.sceneInfo.screenId)
        .findByPersistentId(sceneSession.sceneInfo.persistentId);
      if (containerSession) {
        SCBPcScenePanelManager.getInstance().moveHiddenSessionToAnotherScreenForDisplay(containerSession,
          sceneSession.sceneInfo.screenId, this.screenProperty.screenId);
        // 走窗口合并到另一个屏幕的大小位置处理
        let oldScreenProperty = new SCBScreenProperty();
        const oldMainRect: SCBSessionRect = sceneSession.currRect.copy();
        let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(sceneSession.sceneInfo.screenId);
        oldScreenProperty.copy(screenSession.scbScreenProperty);
        let windowMode = sceneSession.sceneInfo.windowMode;
        switch (windowMode) {
          case SCBSceneMode.FLOATING:
            LayoutPolicyHelper.getInstance().handleFreeWindowRect(sceneSession.currRect, oldScreenProperty,
              this.screenProperty);
            break;
          case SCBSceneMode.FULLSCREEN:
            LayoutPolicyHelper.getInstance().handleFullScreenWindowRect(sceneSession, oldScreenProperty,
              this.screenProperty);
            break;
          default:
            break;
        }
        this.log.showInfo(`moveHiddenSessionToAnotherScreen: sceneSession: ${sceneSession.getName()}, ` +
          `rect from ${oldMainRect.printPx()} change to ${sceneSession.currRect.printPx()}`);
      }
    }
  }

  private queryDpiFromDisplay(screenId: number): number {
    try {
      let defaultDisplay: display.Display = display.getDisplayByIdSync(screenId);
      return defaultDisplay.densityDPI;
    } catch (err) {
      this.log.showError(`queryDpiFromDisplay get dpi error: ${err?.message}`);
      return SCBConstants.DEFAULT_DOTS_PER_INCH;
    }
  }

  private onDisplayChangeCallback = (displayId: number): void => {
    const screenDpi = this.queryDpiFromDisplay(this.screenId);
    // 仅display的density变化时才进入下面的逻辑
    if (screenDpi !== INVALID_DPI && screenDpi !== this.lastDensityFromDisplay) {
      this.lastDensityFromDisplay = screenDpi;
      if (screenDpi !== this.screenDpiDensity) {
        this.updateSessionByDensityChange(screenDpi);
        this.updateScreenDensity(screenDpi);
      }
    }
  }

  private updateSessionByDensityChange(targetDensity: number): void {
    if (this.screenDpiDensity === 0) {
      this.log.showWarn(`onDisplayChangeCallback current screenDensity invalid.`);
      return;
    }

    this.log.showInfo(`updateSessionByDensityChange ` +
      `targetDensity:${targetDensity}, srcDensity:${this.screenDpiDensity}`);
    let subSceneList: SCBSpecificSession[] = [];
    this.updateMainSessionByDensityChange(targetDensity, subSceneList);
    this.updateSubSessionByDensityChange(targetDensity, subSceneList);
    this.refreshSplitWhenDIPChange();
    SCBSceneSessionManager.getInstance().notifyDockAvoidWindow(-1);
  }

  private updateMainSessionByDensityChange(targetDensity: number, subSceneList: SCBSpecificSession[]): void {
    let densityRatio: number = targetDensity / this.screenDpiDensity;

    this.containerSessionList.forEach((sceneContainerSession) => {
      this.updateWindowByDensity(sceneContainerSession, densityRatio);
      if (sceneContainerSession.primarySession &&
        sceneContainerSession.primarySession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
        SCBSceneHelper.updateLastDpi( sceneContainerSession.primarySession, targetDensity);
      }
      subSceneList.push(...this.getSubList(sceneContainerSession));
    })
  }

  private updateWindowByDensity(sceneContainerSession: SCBSceneContainerSession, densityRatio: number): void {
    if (sceneContainerSession && sceneContainerSession.primarySession) {
      let scbSceneSession = sceneContainerSession.primarySession;
      // 自由多窗场景、pc场景、pcMode场景，兼容模式窗口的dpi都不随显示大小档位的调整而变化
      if (scbSceneSession.sceneInfo.screenId === this.screenId &&
        scbSceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
        if (scbSceneSession.isSessionForeground()) {
          this.updateDpiChangeRect(scbSceneSession, densityRatio);
        } else if (scbSceneSession.isSessionBackground()) {
          this.updateDpiChangeRect(scbSceneSession, densityRatio);
        }
      }
    }
  }

  private getSubList(sceneContainerSession: SCBSceneContainerSession): SCBSpecificSceneSessionList {
    let subSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
    if (sceneContainerSession && sceneContainerSession.isSplit &&
    sceneContainerSession.primarySession && sceneContainerSession.secondarySession) {
      if (sceneContainerSession.primarySession.subSessionList !== null) {
        this.traverseGetSubList(sceneContainerSession.primarySession.subSessionList, subSessionList);
      }
      if (sceneContainerSession.secondarySession.subSessionList !== null) {
        this.traverseGetSubList(sceneContainerSession.secondarySession.subSessionList, subSessionList);
      }
    } else if (sceneContainerSession && sceneContainerSession.primarySession) {
      if (sceneContainerSession.primarySession.subSessionList !== null &&
        !sceneContainerSession.primarySession.defaultDensityEnabled) {
        this.traverseGetSubList(sceneContainerSession.primarySession.subSessionList, subSessionList);
      }
    }
    return subSessionList;
  }

  private updateSubSessionByDensityChange(targetDensity: number, subSceneList: SCBSpecificSceneSessionList): void {
    if (subSceneList.length <= 0) {
      return;
    }
    let densityRatio: number = targetDensity / this.screenDpiDensity;
    subSceneList.forEach((specificSession) => {
      if (!specificSession) {
        this.log.showWarn('invalid specific session');
        return;
      }
      // 全屏子窗不跟随DPI变化
      if (this.isFullScreenSpecificSession(specificSession) ||
        specificSession.windowMode === SCBSceneMode.FULLSCREEN) {
        return;
      }
      if (specificSession.session.screenId === this.screenId &&
        (specificSession.sessionState === sceneSessionManager.SessionState.STATE_BACKGROUND ||
        specificSession.sessionState === sceneSessionManager.SessionState.STATE_ACTIVE ||
        specificSession.sessionState === sceneSessionManager.SessionState.STATE_FOREGROUND)) {
        this.updateDpiChangeRect(specificSession, densityRatio);
      }
    })
  }

  private traverseGetSubList(subList: SCBSpecificSceneSessionList, subSceneList: SCBSpecificSceneSessionList): void {
    if (!subList || !subSceneList) {
      return;
    }

    for (let i = 0; i < subList.length; i++) {
      let subItem = subList[i];
      if (!subItem) {
        continue;
      }
      subSceneList.push(subItem);
      if (subItem.subSessionList && subItem.subSessionList.length > 0) {
        this.traverseGetSubList(subItem.subSessionList, subSceneList);
      }
    }
  }

  private isFullScreenSpecificSession(session: SCBSpecificSession): boolean {
    let top = session.currRect.top.getPx();
    let screenRect = new SCBSessionRect(this.screenProperty.left, this.screenProperty.top,
      this.screenProperty.width, this.screenProperty.height);
    return session.currRect.equals(screenRect);
  }

  private updateDpiChangeRect(sceneSession: SCBSceneSession | SCBSpecificSession, scaleRatio: number): void {
    if (!sceneSession) {
      this.log.showInfo('updateDpiChangeRect sceneSession is null');
      return;
    }
    if (sceneSession instanceof SCBSceneSession && sceneSession.defaultDensityEnabled) {
      this.log.showInfo(`updateDpiChangeRect id:${sceneSession.session?.persistentId} not change. use default dpi`);
      return;
    }

    LayoutPolicyHelper.getInstance().updateRectWithDensityChange(sceneSession.currRect, scaleRatio);
    let screenInfo: RealScreenInfo = this.getRealScreenInfo(sceneSession.currRect.top.getPx());
    LayoutPolicyHelper.getInstance().restrictRectWithRealScreenArea(sceneSession.currRect, screenInfo);
    this.notifyFollowParentWindowUpdate(sceneSession);
    this.log.showInfo(`updateDpiChangeRect id:${sceneSession.session?.persistentId}, ` +
      `after change:${sceneSession.currRect.printPx()}`);
  }

  /**
   * 通知需要跟随主窗变化的子窗刷新
   */
  private notifyFollowParentWindowUpdate(sceneSession: SCBSceneSession | SCBSpecificSession) {
    if (sceneSession instanceof SCBSceneSession) {
      // 若此时主窗随DPI调整大小，需同时遍历子窗调整子窗位置
      sceneSession.subSessionList.forEach((item) => {
        item.notifyParentRectChange(sceneSession.currRect, sceneSessionManager.SessionSizeChangeReason.RESIZE,
          sceneSession.sceneInfo.screenId);
      });
    } else {
      // 若此时子窗随DPI调整大小，需重新调整子窗位置
      sceneSession.notifyParentRectChange(sceneSession.currRect, sceneSessionManager.SessionSizeChangeReason.RESIZE,
      sceneSession.screenId, false);
    }
  }

  private refreshSplitWhenDIPChange(): void {
    this.containerSessionList.forEach((sceneContainerSession) => {
      if (sceneContainerSession && sceneContainerSession.isSplit &&
        sceneContainerSession.screenProperty.screenId === this.screenId &&
        sceneContainerSession.primarySession && sceneContainerSession.secondarySession) {
        const rect = LayoutPolicyHelper.getInstance()
          .getSplitInitialRect(this.screenProperty, sceneContainerSession.dividerParam, true);
        const priWidth: number = sceneContainerSession.primarySession.currRect.width.getPx();
        const secWidth: number = sceneContainerSession.secondarySession.currRect.width.getPx();
        const priHeight: number = sceneContainerSession.primarySession.currRect.height.getPx();
        const secHeight: number = sceneContainerSession.secondarySession.currRect.height.getPx();
        const density: number = this.screenDpiDensity / 160;
        const isLessMinWidth: boolean = (sceneContainerSession.dividerParam.primary.minWidth * density > priWidth) ||
          (sceneContainerSession.dividerParam.secondary.minWidth * density > secWidth);
        const isExceedsFullWidth: boolean = priWidth + secWidth + vp2px(DividerStyle.DIVIDER_WIDTH) >
        this.screenProperty.width;
        const isLessMinHeight: boolean = (sceneContainerSession.dividerParam.primary.minHeight * density > priHeight) ||
          (sceneContainerSession.dividerParam.secondary.minHeight * density > secHeight);
        const isExceedsFullHeight: boolean = priHeight + secHeight > rect.height.getPx() * 2;
        if (isLessMinWidth || isExceedsFullWidth || isLessMinHeight || isExceedsFullHeight) {
          sceneContainerSession.notifyRefreshSplitScene();
        }
      }
    })
  }

  private initScreenDpiDensity(): void {
    const screenDpi = this.queryDpiFromDisplay(this.screenProperty.screenId);
    this.lastDensityFromDisplay = screenDpi;
    this.updateScreenDensity(screenDpi);
  }

  private exitSplitIfControl(sceneContainerSession: SCBSceneContainerSession): void {
    let isPrimaryControl = sceneContainerSession.primarySession?.useControlList?.[0] === ControlType.PARENT_CONTROL ||
      sceneContainerSession.primarySession?.useControlList?.[0] === ControlType.APP_LOCK;
    let isSecondaryControl =
      sceneContainerSession.secondarySession?.useControlList?.[0] === ControlType.PARENT_CONTROL ||
        sceneContainerSession.secondarySession?.useControlList?.[0] === ControlType.APP_LOCK;
    if (isPrimaryControl || isSecondaryControl) {
      this.onSceneRecover(isPrimaryControl ? sceneContainerSession.primarySession?.persistentId :
        sceneContainerSession.secondarySession?.persistentId, sceneContainerSession.containerId);
    }
  }
}