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
// import apsManager from '@hms.graphic.apsManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ApsUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
export class ApsUtils {
  public static readonly PKG_NAME = 'com.ohos.sceneboard';
  public static readonly MIDDLE_BUNDLE_NAME = 'middle.bundle';
  // private static sceneAnimation:apsManager.SceneAnimation = apsManager.SceneAnimation.NONE_ANIMATION;
  private static curApsSessionId:string = '';
  private static apsWindowInterValCnt: number = 0;
  private static apsLastVoteCnt: number = 0;
  private static apsWindowAliveCnt: number = 0;
  private static apsWindowTimeoutTimer: number = -1;
  private static HIGH_FRAME_BUNDLE_NAMES: string[] = [];

  /**
   * 通知APS启动连续操作场景，需要持续投票
   * @param sceneName 持续投票场景名称，
   * @return apsApsSessionId id
   */
  // public static startApsPersistentSession(sceneName: apsManager.SceneAnimation): string {
  //   if (this.curApsSessionId !== '') {
  //     this.stopApsSession(this.curApsSessionId);
  //   }
  //   let apsWindowMoveTimerId: number = -1;
  //   this.apsWindowInterValCnt = 0;
  //   this.apsWindowAliveCnt = 0;
  //   this.apsLastVoteCnt = 0;
  //   this.sceneAnimation = sceneName;
  //   this.setApsScene(this.sceneAnimation, 1);
  //   this.apsWindowTimeoutTimer = setInterval(() => {
  //     this.apsWindowInterValCnt++;
  //     if (this.sceneAnimation === apsManager.SceneAnimation.NONE_ANIMATION ||
  //       this.apsWindowInterValCnt - this.apsWindowAliveCnt >= 3) {
  //       this.setApsScene(this.sceneAnimation, 2);
  //       this.curApsSessionId = '';
  //       this.sceneAnimation = apsManager.SceneAnimation.NONE_ANIMATION;
  //       clearInterval(apsWindowMoveTimerId);
  //       this.apsWindowTimeoutTimer = -1;
  //     }
  //   }, 1000);
  //   apsWindowMoveTimerId = this.apsWindowTimeoutTimer;
  //   this.curApsSessionId = sceneName + '_' + Date.now();
  //   return this.curApsSessionId;
  // }

  /**
   * 通知APS心跳
   * @param apsSessionId 投票场景ID，
   * @return false or true
   */
  public static pulseApsSession(apsSessionId: string): boolean {
    /*if (this.sceneAnimation === apsManager.SceneAnimation.NONE_ANIMATION || this.curApsSessionId !== apsSessionId) {
      return false;
    }
    this.apsWindowAliveCnt = this.apsWindowInterValCnt;
    if (this.apsWindowInterValCnt - this.apsLastVoteCnt >= 2) {
      this.setApsScene(this.sceneAnimation, 1);
      this.apsLastVoteCnt = this.apsWindowInterValCnt;
    }*/
    return true;
  }

  /**
   * 通知APS停止投票
   * @param apsSessionId 投票场景ID，
   * @return null
   */
  // public static stopApsSession(apsSessionId: string): void {
  //   if (this.sceneAnimation === apsManager.SceneAnimation.NONE_ANIMATION || this.curApsSessionId !== apsSessionId) {
  //     return;
  //   }
  //   clearInterval(this.apsWindowTimeoutTimer);
  //   this.apsWindowTimeoutTimer = -1;
  //   this.apsWindowInterValCnt = -1;
  //   this.apsWindowAliveCnt = -1;
  //   this.apsLastVoteCnt = -1;
  //   this.setApsScene(this.sceneAnimation, 2);
  //   this.curApsSessionId = '';
  //   this.sceneAnimation = apsManager.SceneAnimation.NONE_ANIMATION;
  // }

  /**
   * 通知APS模块场景启动和结束
   * @param sceneName 场景名称，包括应用启动场景，应用退出场景等
   * @param state 状态 1表示启动0表示结束
   */
  // public static setApsScene(sceneName: apsManager.SceneAnimation, state: number): void {
  //   try {
  //     apsManager?.setScene(this.PKG_NAME, sceneName, state);
  //     log.showDebug(`${sceneName} setApsScene: ${state}`);
  //   } catch (error) {
  //     log.showError(`setApsScene error: ${error}`);
  //   }
  // }

  /**
   * 通知APS模块场景启动和结束(锁90fps场景)
   * @param appPackName 被拉起应用包名
   * @param isIn 应用是否为启动状态
   * @param state 状态 1表示启动0表示结束
   */
  // public static setApsSceneOfContainerInAndOut(appPackName: string, isIn: boolean, state: number): void {
  //   let curSceneName: apsManager.SceneAnimation = this.getSceneName(appPackName, isIn);
  //   let curBundleName: string = this.getBundleName(appPackName);
  //
  //   try {
  //       apsManager?.setScene(curBundleName, curSceneName, state);
  //       log.showDebug(`${curSceneName} setApsSceneOfContainerInAndOut: ${state}`);
  //   } catch (error) {
  //       log.showError(`setApsSceneOfContainerInAndOut, err: ${error?.code}, errMessage: ${error?.message}`);
  //   }
  // }
  //
  // private static getSceneName(appPackName: string, isIn: boolean): apsManager.SceneAnimation {
  //   if (!appPackName || !this.HIGH_FRAME_BUNDLE_NAMES.includes(appPackName)) {
  //     return isIn ? apsManager.SceneAnimation.START_APP_ANIMATION : apsManager.SceneAnimation.BACK_DESKTOP;
  //   } else {
  //     return isIn ? apsManager.SceneAnimation.START_APP_ANIMATION_MIDDLE : apsManager.SceneAnimation.BACK_APP_ANIMATION_MIDDLE;
  //   }
  // }

  private static getBundleName(appPackName: string): string {
    return this.HIGH_FRAME_BUNDLE_NAMES.includes(appPackName) ? this.MIDDLE_BUNDLE_NAME : this.PKG_NAME;
  }

  /**
   * 在list中填加需要限制帧率的hap包名
   * @param allAppPackName 包名字符串(以‘，’分隔)
   */
  public static setAppPackName(allAppPackName: string): void {
    if (!allAppPackName) {
      log.showError(`setAppPackName allAppPackName is null`);
      return;
    }
    let backStr:string = allAppPackName.replace(/\s+/g, '').trim();
    this.HIGH_FRAME_BUNDLE_NAMES.push(...backStr.split(','));
  }
}