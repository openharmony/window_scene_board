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
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils'
import {
  SCBEventId,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionArray,
  SCBSceneSessionManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import { DevScene } from './DevScene';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { SceneConstants } from '@ohos/commonconstants';
import { bundleManager } from '@kit.AbilityKit';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, 'DevScenePanel');

@Component
export struct DevScenePanel {
  @State scbSceneSessionArray: SCBSceneSessionArray = new SCBSceneSessionArray();
  @Link screenProperty: SCBScreenProperty; // current screen property;

  private onStartSceneFromIcon = (sceneInfo: SCBSceneInfo): void => {
    log.showInfo(`onStartSceneFromIcon sceneInfo: ${sceneInfo.bundleName}`);
    for (let i = this.scbSceneSessionArray.length - 1; i >= 0; i--) {
      if (sceneInfo.persistentId === this.scbSceneSessionArray[i].sceneInfo.persistentId) {
        log.showInfo(`update sceneInfo: ${sceneInfo.persistentId}`);
        continue;
      }
      const launchType = this.findLaunchType(this.scbSceneSessionArray[i].sceneInfo);
      if (launchType === bundleManager.LaunchType.SINGLETON) {
        this.sessionBackground(this.scbSceneSessionArray[i]);
      } else {
        log.showInfo(`terminateSession: ${launchType}`);
        this.terminateSessionByPersistentId(this.scbSceneSessionArray[i].sceneInfo.persistentId);
      }
    }
    let oldSession = this.findSceneSessionByPersistentId(sceneInfo.persistentId);
    if (oldSession) {
      log.showInfo('onStartSceneFromIcon found session');
      oldSession.updateSceneInfo(sceneInfo);
      this.sessionActive(oldSession, false);
      return;
    }

    // get form other screen
    let scbSceneSession: SCBSceneSession | undefined = this.popSceneFromOtherScreen(sceneInfo);
    if (scbSceneSession === undefined) {
      scbSceneSession = this.createSceneSession(sceneInfo);
    }
    this.sessionActive(scbSceneSession);
    this.scbSceneSessionArray.push(scbSceneSession);
  }

  private findLaunchType(sceneInfo: SCBSceneInfo): bundleManager.LaunchType {
    const queryKey = `${sceneInfo.bundleName}${sceneInfo.moduleName}${sceneInfo.abilityName}`;
    return SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
  }

  private findSceneSessionIndexByPersistentId(persistentId?: number): number {
    if (!persistentId) {
      return -1;
    }
    let index = this.scbSceneSessionArray.findIndex((value: SCBSceneSession) => {
      if (value.session.persistentId && value.session.persistentId === persistentId) {
        return true;
      }
      return false;
    });
    return index;
  }

  private findSceneSessionByPersistentId(persistentId?: number): SCBSceneSession | undefined {
    let index = this.findSceneSessionIndexByPersistentId(persistentId);
    if (index >= 0) {
      return this.scbSceneSessionArray[index];
    }
    return undefined;
  }

  private sessionBackground(session: SCBSceneSession) {
    session.visibility = false;
    session.requestSessionBackground();
  }

  private sessionActive(session: SCBSceneSession, isNewActive?: boolean) {
    session.visibility = true;
    session.requestSessionActivation(isNewActive);
  }

  /**
   * 根据窗口信息查找对应的窗口会话
   *
   * @param sceneInfo - 要查找的窗口信息
   * @returns 找到的窗口会话，如果未找到则返回undefined
   */
  public getSCBSceneSessionBySceneInfo(sceneInfo: SCBSceneInfo): SCBSceneSession | undefined {
    return this.scbSceneSessionArray.find(scbSceneSession =>
    scbSceneSession.sceneInfo?.equalTo(sceneInfo)
    );
  }

  /**
   * 窗口迁移，从当前屏幕迁移出去
   *
   * @param sceneInfo - 窗口信息
   * @returns 返回窗口会话，如果未找到对应窗口返回undefined
   */
  private popSceneSession = (sceneInfo: SCBSceneInfo): SCBSceneSession | undefined => {
    log.showInfo(`popSceneSession started, bundleName:${sceneInfo.bundleName}`);
    if (!sceneInfo) {
      log.showError('sceneInfo is undefined');
      return undefined;
    }
    let scbSceneSession = this.getSCBSceneSessionBySceneInfo(sceneInfo);
    if (!scbSceneSession) {
      log.showError(`not find scbSceneSession`);
      return undefined;
    }
    log.showInfo(`scbSceneSession isActive:${scbSceneSession.isActive}`);
    if (scbSceneSession.isActive) {
      this.sessionBackground(scbSceneSession);
    }
    let index = this.findSceneSessionIndexByPersistentId(scbSceneSession.session.persistentId);
    if (index >= 0) {
      this.scbSceneSessionArray.splice(index, 1);
    }
    return scbSceneSession;
  }

  /**
   * @description 在其他屏幕的任务里查找此应用，找到了从原list里移出，此后续过程异步处理
   * @param sceneInfo
   */
  public popSceneFromOtherScreen(sceneInfo: SCBSceneInfo): SCBSceneSession | undefined {
    const sceneSession = SCBSceneSessionManager.getInstance().popSceneFromOtherScreen(sceneInfo);
    if (sceneSession === undefined) {
      return undefined;
    }
    sceneInfo.persistentId = sceneSession.session.persistentId;
    sceneInfo.screenId = this.screenProperty.screenId;
    log.info(`find sceneSession in other screen ${sceneSession.sceneInfo.bundleName}`);
    const newSceneSession = new SCBSceneSession(sceneSession.session, sceneInfo);
    newSceneSession.subSessionList = sceneSession.subSessionList.map((item) => {
      SCBSceneSessionManager.getInstance().updateSessionDisplayId(item.session.persistentId,
        this.screenProperty.screenId);
      return item;
    });
    return newSceneSession;
  }

  private createSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession {
    let sceneSession: sceneSessionManager.SceneSession = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo.bundleName,
      moduleName: sceneInfo.moduleName,
      abilityName: sceneInfo.abilityName,
      appIndex: sceneInfo.appIndex,
      persistentId: sceneInfo.persistentId,
      screenId: sceneInfo.screenId
    }, sceneInfo.want);
    sceneInfo.persistentId = sceneSession.persistentId;
    sceneInfo.screenId = this.screenProperty?.screenId;
    return new SCBSceneSession(sceneSession, sceneInfo);
  }

  private terminateSessionByPersistentId(persistentId?: number): void {
    let index = this.findSceneSessionIndexByPersistentId(persistentId);
    log.showInfo(`TerminateScene ${index} ${persistentId}`);
    if (index >= 0) {
      this.scbSceneSessionArray[index]?.requestSessionDestruction(true);
      this.scbSceneSessionArray.splice(index, 1);
    }
  }

  private onTerminateScene = (persistentId?: number, containerId?: number): void => {
    log.showInfo(`onTerminateScene persistentId: ${persistentId}`);
    this.terminateSessionByPersistentId(persistentId);
    if (this.scbSceneSessionArray.length > 0) {
      let activeIndex = this.scbSceneSessionArray.findIndex((value: SCBSceneSession) => {
        if (value.isActive && value.visibility) {
          return true;
        }
        return false;
      });
      if (activeIndex < 0) {
        this.sessionActive(this.scbSceneSessionArray[this.scbSceneSessionArray.length - 1], false);
      }
    }
  }

  private onMinimizeScene = (persistentId?: number, containerId?: number): void => {
    log.info(`onMinimizeScene persistentId: ${persistentId}`);
    let index = this.findSceneSessionIndexByPersistentId(persistentId);
    if (index < 0) {
      log.showError(`onMinimizeScene not find sceneSession`);
      return;
    }
    log.info(`onMinimizeScene scbSceneSessionArray.len ${this.scbSceneSessionArray.length}`);
    const launchType = this.findLaunchType(this.scbSceneSessionArray[index].sceneInfo);
    if (launchType === bundleManager.LaunchType.SINGLETON) {
      log.info(`sessionBackground: ${launchType}`);
      this.sessionBackground(this.scbSceneSessionArray[index]);
    } else {
      log.info(`terminateSession: ${launchType}`);
      this.terminateSessionByPersistentId(this.scbSceneSessionArray[index].sceneInfo.persistentId);
    }
    if (this.scbSceneSessionArray.length > 0) {
      let activeIndex = this.scbSceneSessionArray.findIndex((value: SCBSceneSession) => {
        if (value.isActive && value.visibility) {
          return true;
        }
        return false;
      });
      log.info(`onBackgroundScene activeIndex: ${activeIndex}`);
      if (activeIndex < 0) {
        this.sessionActive(this.scbSceneSessionArray[0], false);
      }
    }
  }

  private registerCallback(): void {
    SCBSceneSessionManager.getInstance()
      .registerVirtualScreenStartScene(this.onStartSceneFromIcon, this.screenProperty.screenId);
  }

  private registerSessionEvent(): void {
    SCBSceneSessionManager.getInstance().on(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId,
      this.onTerminateScene);
    if (DeviceHelper.isEmulator()) {
      SCBSceneSessionManager.getInstance().on(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId,
        this.onMinimizeScene);
      SCBSceneSessionManager.getInstance().on(SCBEventId.SESSION_EXCEPTION, this.screenProperty.screenId,
        this.onTerminateScene);
    }
  }

  private unRegisterSessionEvent(): void {
    SCBSceneSessionManager.getInstance().off(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId,
      this.onTerminateScene);
    if (DeviceHelper.isEmulator()) {
      SCBSceneSessionManager.getInstance().off(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId,
        this.onMinimizeScene);
      SCBSceneSessionManager.getInstance().off(SCBEventId.SESSION_EXCEPTION, this.screenProperty.screenId,
        this.onTerminateScene);
    }
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear screenId: ${this.screenProperty.screenId}`);
    this.registerCallback();
    this.registerSessionEvent();
    SCBSceneSessionManager.getInstance().registerPopSceneSession(this.popSceneSession, this.screenProperty.screenId);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear onTerminateScene');
    this.scbSceneSessionArray.forEach((session: SCBSceneSession) => {
      log.showInfo(`onTerminateScene for ${session.session.persistentId}`);
      // 销毁容器中的当前主窗
      session.requestSessionDestruction(true);
    });
    this.scbSceneSessionArray.splice(0);
    SCBSceneSessionManager.getInstance()
      .unregisterVirtualScreenStartScene(this.screenProperty.screenId);
    this.unRegisterSessionEvent();
    SCBSceneSessionManager.getInstance().unregisterPopSceneSession(this.screenProperty.screenId);
  }

  build() {
    WindowScene(SceneConstants.TRANSFORM_SCENE) {
      Stack({ alignContent: Alignment.TopStart }) {
        ForEach(this.scbSceneSessionArray, (scbSceneSession: SCBSceneSession) => {
          DevScene({
            sceneSession: scbSceneSession,
            scbScreenProperty: this.screenProperty
          })
        }, (scbSceneSession: SCBSceneSession) => `devecoviewer_session_${scbSceneSession.session.persistentId}`)
      }
      .backgroundColor('sys.color.ohos_id_color_background')
      .width(StyleConstants.PERCENTAGE_100)
      .height(StyleConstants.PERCENTAGE_100)
      .hitTestBehavior(HitTestMode.None)
    }
  }
}