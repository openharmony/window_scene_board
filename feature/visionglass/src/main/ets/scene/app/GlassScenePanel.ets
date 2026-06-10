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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneMode,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import { sEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { curves } from '@kit.ArkUI';
import { GlassAppWhiteListManager } from '../../common/manager/GlassAppWhiteListManager';
import { SceneZOrderManager } from '../../common/manager/SceneZOrderManager';
import { GlassSceneManager } from '../common/GlassSceneManager';
import { GlassScene } from './GlassScene';
import NotificationConstant from '../../notificationcenter/common/NotificationConstant';
import { GlassStatusManager } from '../../common/manager/GlassStatusManager';
import { GlassShowToastOptions, GlassToastManager } from '../../toast/manager/GlassToastManager';
import { GlassAppWhiteListToastCommon } from '../../common/constants/GlassLayoutConstants';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassScenePanel');
const INVALID_INDEX: number = -1;
const ALICE_BUNDLE_NAME: string = 'com.ohos.visionglass';
const CONTACT_BUNDLE_NAME: string = 'com.ohos.contacts';
const ENTRY_ABILITY: string = 'EntryAbility';
const ENTRY: string = 'entry';

@Component
export struct GlassScenePanel {
  @State mOpacity: number = 1;
  @State containerSessionList: SCBSceneSession[] = [];
  @State activeContainerSessionIndex: number = INVALID_INDEX;
  @Consume screenId: number;
  @Link screenProperty: SCBScreenProperty;
  @State isStartApp: boolean = false;
  private panelMgr = SCBScenePanelManager.getInstance(this.screenProperty);
  private containerSessionArray: SCBSceneContainerSessionArray = this.panelMgr.getSceneContainerSessionList();
  private topActiveSession = this.containerSessionArray.getTopActiveSession();
  private findSceneSession = (sceneInfo: SCBSceneInfo): number => {
    return this.containerSessionList.findIndex((containerSession: SCBSceneSession) => {
      const res = containerSession.sceneInfo.equalTo(sceneInfo);
      return res;
    })
  }
  private createSceneSession = (sceneInfo: SCBSceneInfo): SCBSceneSession | undefined => {
    const session = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
    if (!session) {
      log.error('Failed to request scene session!');
      return undefined;
    }
    sceneInfo.persistentId = session.persistentId;
    sceneInfo.screenId = this.screenId;
    return new SCBSceneSession(session, sceneInfo);
  }

  private requestSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession | undefined {
    let sceneSession: SCBSceneSession | undefined =
      SCBSceneSessionManager.getInstance().popSceneFromOtherScreen(sceneInfo);
    if (sceneSession !== undefined) {
      if (sceneSession.isNewWant) {
        log.info(`find sceneSession in other screen ${sceneSession.sceneInfo.bundleName}`);
        sceneSession = this.copySceneSession(sceneSession, sceneInfo);
        return sceneSession;
      } else {
        log.info(`isNewWant false, so destroy in scenepanel`);
        SCBSceneSessionManager.getInstance().requestSceneContainerDestruction(sceneSession.sceneInfo.screenId,
          sceneSession.sceneInfo.persistentId);
      }
    }
    sceneSession = this.popSceneSession(sceneInfo);
    if (sceneSession !== undefined) {
      log.info(`sceneSession is already existed in glass ${sceneSession.sceneInfo.bundleName}`);
      return sceneSession;
    }
    sceneSession = this.createSceneSession(sceneInfo);
    return sceneSession;
  }

  private popSceneSessionWithIndex(index: number): SCBSceneSession {
    const containerSession = this.containerSessionList[index];
    const isActive = containerSession.isActive;
    if (isActive) {
      containerSession.requestSessionBackground();
    }
    this.containerSessionList.splice(index, 1);
    GlassStatusManager.getInstance().activeAppScene?.dispatch((set) => {
      set.delete(containerSession);
      return set;
    })
    return containerSession;
  }

  private popSceneSession = (sceneInfo: SCBSceneInfo): SCBSceneSession | undefined => {
    const index = this.findSceneSession(sceneInfo);
    if (index === INVALID_INDEX) {
      return undefined;
    }
    return this.popSceneSessionWithIndex(index);
  }
  private minimizeAllScene = (): void => {
    log.showInfo(`minimizeAllScene, sceneIndex: ${this.activeContainerSessionIndex}`);
    GlassStatusManager.getInstance().activeAppScene?.dispatch((set) => {
      set.clear();
      return set;
    })
    if (this.activeContainerSessionIndex !== INVALID_INDEX) {
      this.activeContainerSessionRequestBackground();
    } else {
      log.showWarn('minimizeAllScene activeContainerSessionIndex is invalid');
    }
  };

  private activeContainerSessionRequestBackground(): void {
    log.showInfo(`activeContainerSessionRequestBackground activeContainerSessionIndex: ${this.activeContainerSessionIndex}`);
    if (this.activeContainerSessionIndex !== INVALID_INDEX) {
      const currContainerSession: SCBSceneSession = this.containerSessionList[this.activeContainerSessionIndex];
      this.containerSessionRequestBackground(currContainerSession);
      this.activeContainerSessionIndex = INVALID_INDEX;
    }
  }

  private containerSessionRequestBackground(containerSession?: SCBSceneSession): void {
    if (CheckEmptyUtils.isEmpty(containerSession)) {
      log.showWarn('containerSessionRequestBackground, containerSession is empty');
      return;
    }
    if (containerSession?.session) {
      log.showInfo('containerSessionRequestBackground, requestSceneSessionBackground');
      this.requestSceneSessionBackground(containerSession?.session, true);
    } else {
      log.showWarn('containerSessionRequestBackground sceneSession is empty');
    }
  }

  private findCurrentActivateScene = (): number => {
    if (this.activeContainerSessionIndex !== INVALID_INDEX) {
      return this.containerSessionList[this.activeContainerSessionIndex]?.session?.persistentId;
    }
    return 0;
  }
  private copySceneSession = (sceneSession: SCBSceneSession, sceneInfo: SCBSceneInfo): SCBSceneSession => {
    sceneInfo.persistentId = sceneSession.session.persistentId;
    sceneInfo.screenId = this.screenId;
    const glassSceneSession = new SCBSceneSession(sceneSession.session, sceneInfo);
    glassSceneSession.subSessionList = sceneSession.subSessionList.map((item) => {
      GlassSceneManager.getInstance().updateSessionDisplayId(item.session.persistentId, this.screenId);
      return item;
    });
    return glassSceneSession;
  }

  private requestSceneSessionActivation(sceneSession: sceneSessionManager.SceneSession | undefined,
    isNewActive: boolean): void {
    if (CheckEmptyUtils.isEmpty(sceneSession)) {
      log.showWarn('requestSceneSessionActivation, sceneSession is empty');
      return;
    }
    SCBSceneSessionManager.getInstance().requestSceneSessionActivation(sceneSession, isNewActive);
    log.info('requestSceneSessionActivation succeed');
  }

  private requestSceneSessionBackground(sceneSession: sceneSessionManager.SceneSession | undefined,
    isDelegator?: boolean): void {
    if (CheckEmptyUtils.isEmpty(sceneSession)) {
      log.showWarn('requestSceneSessionBackground, sceneSession is empty');
      return;
    }
    SCBSceneSessionManager.getInstance().requestSceneSessionBackground(sceneSession, isDelegator);
    log.info('requestSceneSessionBackground succeed');
  }

  private contactsAdapt = (sceneInfo: SCBSceneInfo): SCBSceneInfo => {
    if (sceneInfo?.want?.bundleName !== CONTACT_BUNDLE_NAME) {
      return sceneInfo;
    }
    if (sceneInfo.want.parameters !== undefined) {
      sceneInfo.want.parameters.XRDeviceType = 'vision glass';
    } else {
      sceneInfo.want.parameters = {
        XRDeviceType: 'vision glass'
      };
    }
    return sceneInfo;
  };
  private startScene = (sceneInfo: SCBSceneInfo): void => {
    if (CheckEmptyUtils.isEmpty(sceneInfo)) {
      log.showWarn('sceneInfo is empty');
      return;
    }
    let isSpecialBundleName: boolean = sceneInfo.bundleName === NotificationConstant.PHONE_BUNDLE_NAME;
    let isWhiteListApp: boolean =
      isSpecialBundleName ? true : GlassAppWhiteListManager.getInstance().isWhiteListApp(sceneInfo.bundleName);
    if (!isWhiteListApp) {
      let toastMassage = GlassAppWhiteListManager.getInstance().getAppName(sceneInfo.bundleName);
      log.showWarn(`sceneInfo is not in WhiteList, app name is: ${toastMassage}`);
      let options: GlassShowToastOptions = {
        message: GlassAppWhiteListToastCommon.getAddMsg(toastMassage),
        bottom: GlassAppWhiteListToastCommon.TOAST_BOTTOM,
        duration: GlassAppWhiteListToastCommon.TOAST_DURATION,
        width: GlassAppWhiteListToastCommon.ADD_APP_TO_GLASS_WID
      }
      GlassToastManager.getInstance().showToast(options);
      return;
    }
    log.showInfo(`before startScene sceneInfo: ${sceneInfo.bundleName} activeContainerSessionIndex: ${this.activeContainerSessionIndex}`);
    if (this.activeContainerSessionIndex !== INVALID_INDEX) {
      const currActiveContainerSession: SCBSceneSession = this.containerSessionList[this.activeContainerSessionIndex];
      if (CheckEmptyUtils.isEmpty(currActiveContainerSession)) {
        this.activeContainerSessionIndex = INVALID_INDEX;
        log.showWarn('activeContainerSession is invalid!');
      } else if (currActiveContainerSession.sceneInfo.bundleName === sceneInfo.bundleName &&
        currActiveContainerSession.sceneInfo.abilityName === sceneInfo.abilityName) {
        log.showWarn(`startScene, app ability is same, bundleName: ${sceneInfo.bundleName}, abilityName: ${sceneInfo.abilityName}`);
        return;
      } else {
        GlassStatusManager.getInstance().activeAppScene?.dispatch((set) => {
          set.delete(currActiveContainerSession);
          return set;
        })
        this.requestSceneSessionBackground(currActiveContainerSession.session, true);
        this.activeContainerSessionIndex = INVALID_INDEX;
      }
    }

    let containerIndex: number = this.containerSessionList.findIndex((sessionItem: SCBSceneSession) => {
      return sessionItem.sceneInfo.bundleName === sceneInfo.bundleName &&
        sessionItem.sceneInfo.abilityName === sceneInfo.abilityName;
    });
    log.showInfo(`startScene find containerIndex: ${containerIndex}`);

    let hasFound: boolean = containerIndex !== INVALID_INDEX;
    if (!hasFound) {
      let sceneContainerSession = this.requestSceneSession(sceneInfo);
      if (sceneContainerSession === undefined) {
        log.info('sceneSession is undefined');
        return;
      }
      GlassStatusManager.getInstance().activeAppScene?.dispatch((set) => {
        set.add(sceneContainerSession as SCBSceneSession);
        return set;
      })
      this.containerSessionList.push(sceneContainerSession);
      containerIndex = this.containerSessionList.length - 1;
    } else {
      this.updateSceneCallerInfo(this.containerSessionList[containerIndex], sceneInfo);
    }

    const activeContainerSession: SCBSceneSession = this.containerSessionList[containerIndex];
    this.contactsAdapt(activeContainerSession.sceneInfo);
    const activeSceneSession: sceneSessionManager.SceneSession | undefined = activeContainerSession.session;
    if (CheckEmptyUtils.isEmpty(activeSceneSession)) {
      log.showError('The activeSceneSession is empty');
      return;
    }
    GlassStatusManager.getInstance().activeAppScene?.dispatch((set) => {
      set.add(activeContainerSession as SCBSceneSession);
      return set;
    })
    this.requestSceneSessionActivation(activeSceneSession, true);
    activeContainerSession.setZOrder(SceneZOrderManager.APP_SCENE);
    this.activeContainerSessionIndex = containerIndex;
    this.mOpacity = 1;
    log.info(`after startScene activeContainerSessionIndex: ${this.activeContainerSessionIndex}`);
    this.isStartApp = false;
  };

  private updateSceneCallerInfo(containerSession: SCBSceneSession, sceneInfo: SCBSceneInfo): void {
    if (CheckEmptyUtils.isEmpty(containerSession) || CheckEmptyUtils.isEmpty(sceneInfo)) {
      log.showWarn('containerSession or sceneInfo is empty');
      return;
    }
    const containerSceneInfo: SCBSceneInfo = containerSession?.sceneInfo as SCBSceneInfo;
    log.showInfo('scene session is found, update the callerInfo');
    containerSceneInfo.callerPersistentId = sceneInfo.callerPersistentId;
    containerSceneInfo.callerBundleName = sceneInfo.callerBundleName;
    containerSceneInfo.callerAbilityName = sceneInfo.callerAbilityName;
  }

  private terminateScene = (persistentId: number): void => {
    const index = this.containerSessionList.findIndex((containerSession: SCBSceneSession) => {
      return containerSession.session.persistentId === persistentId
    });
    if (index === INVALID_INDEX) {
      return;
    }
    const containerSession = this.containerSessionList[index];
    log.info(`${persistentId} begin to requestSessionDestruction`);
    GlassStatusManager.getInstance().activeAppScene?.dispatch((set) => {
      set.delete(containerSession as SCBSceneSession);
      return set;
    })
    containerSession.requestSessionDestruction(true);
    log.info(`${persistentId} succeed in requestSessionDestruction`);
    this.containerSessionList.splice(index, 1);
  }
  private terminateLastScene = (): void => {
    const lastIndex = this.containerSessionList.length - 1;
    const containerSession = this.containerSessionList[lastIndex];
    if (containerSession?.isActive) {
      log.info('glassScenePanel terminateLastScene');
      GlassStatusManager.getInstance().activeAppScene?.dispatch((set) => {
        set.delete(containerSession as SCBSceneSession);
        return set;
      })
      containerSession.requestSessionDestruction(true);
      this.containerSessionList.splice(lastIndex, 1);
    }
  }
  private getSessionById = (persistentId: number): SCBSceneSession | undefined => {
    const index = this.containerSessionList.findIndex((containerSession: SCBSceneSession) => {
      return containerSession.session.persistentId === persistentId;
    });
    if (index === INVALID_INDEX) {
      log.error('index is invalid, return');
      return undefined;
    }
    return this.containerSessionList[index];
  };
  private getActiveWant = (): Want | undefined => {
    if (this.activeContainerSessionIndex === INVALID_INDEX) {
      return undefined;
    }
    let activeScene = this.containerSessionList[this.activeContainerSessionIndex];
    if (activeScene) {
      return activeScene.sceneInfo.want;
    }
    return undefined;
  };
  private getActiveSession = (): SCBSceneSession | undefined => {
    this.containerSessionArray = this.panelMgr.getSceneContainerSessionList();
    this.topActiveSession = this.containerSessionArray.getTopActiveSession();
    if (this.topActiveSession?.primarySession?.sceneInfo.bundleName === ALICE_BUNDLE_NAME &&
      this.topActiveSession?.primarySession?.sceneInfo.abilityName === ENTRY_ABILITY) {
      log.info(`topActiveSession is Alice, return`);
      return this.topActiveSession?.primarySession;
    }
    return undefined;
  };
  private isAliceAppForeground = (): boolean => {
    this.containerSessionArray = this.panelMgr.getSceneContainerSessionList();
    this.topActiveSession = this.containerSessionArray.getTopActiveSession();
    if (this.topActiveSession?.primarySession?.sceneInfo?.bundleName === ALICE_BUNDLE_NAME &&
      this.topActiveSession?.primarySession?.sceneInfo?.abilityName === ENTRY_ABILITY) {
      log.info('topActiveSession is Alice, do nothing');
      return true;
    }
    return false;
  };
  private startAliceApp = (): void => {
    log.info('startAliceApp');
    let aliceSceneInfo: SCBSceneInfo = new SCBSceneInfo(ALICE_BUNDLE_NAME, ENTRY, ENTRY_ABILITY);
    aliceSceneInfo.screenId = 0;
    this.updateWant(aliceSceneInfo)
    SCBSceneSessionManager.getInstance().startSceneFromOther(aliceSceneInfo);
    this.isStartApp = true;
  };
  private appFlowToGlass = (): void => {
    let primarySession = this.topActiveSession?.primarySession;
    if (!primarySession) {
      log.info('topActiveSession is null');
      return;
    }
    let sceneInfo = primarySession.sceneInfo;
    let bundleName = primarySession.sceneInfo.bundleName;
    let isSpecialBundleName: boolean = bundleName === NotificationConstant.PHONE_BUNDLE_NAME;
    let isWhiteListApp: boolean =
      isSpecialBundleName ? true : this.filterVgFromWhiteList(bundleName);
    log.showDebug(`topActiveSession bundleName is ${bundleName}; isWhiteListApp: ${isWhiteListApp};`);
    if (isWhiteListApp) {
      sceneInfo.screenId = 1;
      this.startScene(sceneInfo);
    }
    this.isStartApp = false;
  };

  private filterVgFromWhiteList(bundleName: string): boolean {
    let appInWhiteList: boolean;
    let appWhiteList: Want[] = GlassAppWhiteListManager.getInstance().getWhiteList();

    // 过滤vision glass应用
    if (bundleName === ALICE_BUNDLE_NAME) {
      appInWhiteList = appWhiteList?.find((item: Want) => item.moduleName === ENTRY &&
        item.abilityName === ENTRY_ABILITY) !== undefined;
      return appInWhiteList;
    }
    appInWhiteList = appWhiteList.find((item: Want) => item.bundleName === bundleName) !== undefined;
    return appInWhiteList;
  }

  private updateWant(sceneInfo: SCBSceneInfo): void {
    let want = sceneInfo.want;
    let params = new Map<String, Object>();
    params.set('windowMode', SCBSceneMode.FULLSCREEN);
    if (CheckEmptyUtils.isEmpty(want)) {
      sceneInfo.want = {
        bundleName: sceneInfo.bundleName,
        abilityName: sceneInfo.abilityName,
        moduleName: sceneInfo.moduleName,
        parameters: {
          startParams: params,
        }
      };
    } else {
      sceneInfo.want.parameters = {
        startParams: params,
      };
    }
  };

  private onScreenConnect = (): void => {
    log.info(`onScreenConnect`);
    if (!this.isAliceAppForeground()) {
      this.startAliceApp();
      let currentWhiteList = GlassAppWhiteListManager.getInstance().getWhiteList();
      if (currentWhiteList.length !== 0) {
        this.appFlowToGlass();
      }
    }
    return;
  };
  private appRemoveFromGlass = (): void => {
    let currGlassSession: SCBSceneSession = this.containerSessionList[this.activeContainerSessionIndex];
    if (!currGlassSession) {
      log.info('topActiveSession is null');
      return;
    }
    let bundleName = currGlassSession.sceneInfo.bundleName;
    let isSpecialBundleName: boolean = bundleName === NotificationConstant.PHONE_BUNDLE_NAME;
    let isWhiteListApp: boolean =
      isSpecialBundleName ? true : GlassAppWhiteListManager.getInstance().isWhiteListApp(bundleName);
    log.debug(`topActiveSession bundleName is ${bundleName}; isWhiteListApp: ${isWhiteListApp};`);
    if (!isWhiteListApp) {
      this.minimizeAllScene();
    } else {
      return;
    }
  };

  private whiteListUpdateDeal(): void {
    let currentWhiteList = GlassAppWhiteListManager.getInstance().getWhiteList()
    if (this.isStartApp) {
      if (currentWhiteList.length !== 0) {
        this.appFlowToGlass();
      } else {
        return;
      }
    } else {
      this.appRemoveFromGlass();
    }
  };

  private updateGlassWhiteList = (enable: boolean) => {
    log.info(`updateGlassWhiteList ${enable} `);
    this.whiteListUpdateDeal();
  }

  aboutToAppear() {
    log.info(`aboutToAppear screenId: ${this.screenId}`);
    sEventManager.subscribe('updateGlassWhiteList', this.updateGlassWhiteList);
    GlassSceneManager.getInstance().registerScenePanelCallback({
      minimizeAllScene: this.minimizeAllScene,
      popSceneSession: this.popSceneSession,
      startScene: this.startScene,
      getContainerSessionList: (): SCBSceneSession[] => this.containerSessionList,
      terminateScene: this.terminateScene,
      getSessionById: this.getSessionById,
      terminateLastScene: this.terminateLastScene,
      findCurrentActivateScene: this.findCurrentActivateScene,
      isAliceAppForeground: this.isAliceAppForeground,
      getActiveWant: this.getActiveWant,
      getActiveSession: this.getActiveSession,
    });
    setTimeout(() => {
      this.onScreenConnect();
    }, 500);
  }

  aboutToDisappear(): void {
    log.info('aboutToDisappear');
    sEventManager.off('updateGlassWhiteList', this.updateGlassWhiteList);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      ForEach(this.containerSessionList, (containerSession: SCBSceneSession, index: number) => {
        if (this.activeContainerSessionIndex === index) {
          GlassScene({
            sceneSession: containerSession,
            screenProperty: this.screenProperty
          })
        }
      })
    }
    .size({ width: '100%', height: '100%' })
    .hitTestBehavior(HitTestMode.None)
    .opacity(this.mOpacity)
    .visibility(this.activeContainerSessionIndex !== INVALID_INDEX ? Visibility.Visible : Visibility.None)
  }
}