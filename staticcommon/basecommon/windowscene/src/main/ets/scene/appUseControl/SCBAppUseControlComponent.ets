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

import { SCBSceneSession, ActiveReason } from '../session/SCBSceneSession';
import { SCBSceneSessionManager, ScenePanelState } from '../session/SCBSceneSessionManager';
import { SCBSceneMode } from '../session/SCBSceneInfo';
import { ComponentBuilderParam, ControlType, SCBAppUseControlManager} from './SCBAppUseControlManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { BusinessError } from '@ohos.base';

const TAG = 'UseControlComponent';
const ERROR_RELEASE_CODE = 1;
const MAX_RECONNECT_COUNT = 1;
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct SCBAppUseControlComponent {
  @Prop isSessionActive: boolean = false;
  @Prop scenePanelState: ScenePanelState = ScenePanelState.RECENT;
  sceneSession: SCBSceneSession | null = null;
  @Prop builderParam: ComponentBuilderParam | null = null;
  private bundleName: string = '';
  private appIndex: number = 0;
  private uiExtensionType: string = 'sys/commonUI';
  private activeReason: ActiveReason | undefined = undefined;
  private uiExtProxy?: UIExtensionProxy;
  private appUseControlWindowModeCallBack = (windowMode: SCBSceneMode) => {
    log.showInfo(`[UseControl] notify window mode change, persistentId: ${this.sceneSession?.persistentId}` +
      ` windowMode: ${windowMode}`);
    this.uiExtProxy?.send({
      'bundleName': this.bundleName,
      'appIndex': this.appIndex,
      'userId': SCBSceneSessionManager.getInstance().getCurrentUserId(),
      'mainWindowMode': windowMode
    });
  }

  @BuilderParam useControlMainMaskBuilder: () => void;
  @BuilderParam useControlRecentMaskBuilder: () => void;
  @State reconnectCount: number = 0;

  aboutToAppear(): void {
    log.showInfo(`[UseControl]aboutToAppear persistentId:${this.sceneSession?.session?.persistentId} ` +
      `controlType:${this.sceneSession?.useControlList?.[0]}`);
    if (!this.sceneSession || !this.builderParam) {
      log.showError(`[UseControl]aboutToAppear sceneSession or builderParam is null`);
      return;
    }
    this.bundleName = this.sceneSession?.sceneInfo.bundleName;
    this.appIndex = this.sceneSession?.sceneInfo.appIndex;
    this.activeReason = this.sceneSession?.sessionData.activeReason;
    this.sceneSession?.useControlSession?.setVisibility(true);
    SCBAppUseControlManager.getInstance()
      .registerAppUseControlWindowModeCallBack(this.sceneSession.persistentId, this.appUseControlWindowModeCallBack);
  }

  aboutToDisappear(): void {
    log.showInfo(`[UseControl]aboutToDisappear persistentId:${this.sceneSession?.session?.persistentId} ` +
      `controlType:${this.sceneSession?.useControlList?.[0]}`);
    this.sceneSession?.useControlSession?.setVisibility(false);
    if (!this.sceneSession) {
      log.showError(`[UseControl]aboutToDisappear sceneSession is invalid`);
      return;
    }
    this.sceneSession.sessionData.activeReason = ActiveReason.DEFAULT;
    SCBAppUseControlManager.getInstance().unRegisterAppUseControlWindowModeCallBack(this.sceneSession.persistentId);
  }

  build() {
    Stack() {
      if (this.buildLog()) {}
      if (this.isNeedShowMainMask() || (this.sceneSession?.useControlList?.[0] === ControlType.PARENT_CONTROL)) {
        WindowScene(this.sceneSession?.useControlSession?.session.persistentId) {
          Stack() {
            if (this.hasMainMaskBuilder()) {
              this.useControlMainMaskBuilder();
            }
            UIExtensionComponent({
              bundleName: this.builderParam?.loadBundleName,
              abilityName: this.builderParam?.loadAbilityName,
              parameters: {
                'ability.want.params.uiExtensionType': this.uiExtensionType,
                'bundleName': this.bundleName,
                'appIndex': this.appIndex,
                'persistentId': this.sceneSession?.session?.persistentId,
                'userId': SCBSceneSessionManager.getInstance().getCurrentUserId(),
                'reconnectCount': this.reconnectCount,
                'activeReason': this.activeReason,
                'mainWindowMode': this.sceneSession?.sceneInfo.windowMode
              }
            })
              .size({ width: '100%', height: '100%' })
              .onRemoteReady((proxy) => {
                this.uiExtProxy = proxy;
                log.showInfo('[UseControl]UIExtension ready');
              })
              .onError((error: BusinessError) => {
                log.showError(`[UseControl]UIExtension error:${error.message} reconnect:${this.reconnectCount}`);
                if (this.reconnectCount < MAX_RECONNECT_COUNT) {
                  this.reconnectCount++;
                }
              })
              .onRelease((code) => {
                log.showInfo(`[UseControl]UIExtension release code:${code} reconnect:${this.reconnectCount}`);
                if (code === ERROR_RELEASE_CODE && this.reconnectCount < MAX_RECONNECT_COUNT) {
                  this.reconnectCount++;
                }
              })
              .onReceive((data) => {
                log.showInfo('[UseControl]UIExtension receive');
              })
          }
        }.size({ width: '100%', height: '100%' })
        .transition(TransitionEffect.IDENTITY)
      } else {
        WindowScene(this.sceneSession?.useControlSession?.session.persistentId) {
          if (this.hasRecentMaskBuilder()) {
            this.useControlRecentMaskBuilder();
          }
        }.size({ width: '100%', height: '100%' })
        .transition(TransitionEffect.IDENTITY)
      }
    }.width('100%').height('100%')
  }

  private buildLog(): boolean {
    log.showInfo(`[UseControl]build bundleName:${this.bundleName} isSessionActive:${this.isSessionActive}` +
      ` persistentId:${this.sceneSession?.useControlSession?.session.persistentId}` +
      ` scenePanelState:${this.scenePanelState}` +
      ` isControlRecentOnly:${this.sceneSession?.controlTypeToControlRecentMap?.get(this.sceneSession?.useControlList?.[0])}` +
      ` mainWindowMode:${this.sceneSession?.sceneInfo.windowMode}}`);
    return true;
  }

  private hasMainMaskBuilder(): boolean {
    if (!this.builderParam) {
      return false;
    }
    this.useControlMainMaskBuilder = this.builderParam!.useControlMainMaskBuilder;
    return this.useControlMainMaskBuilder != null;
  }

  private hasRecentMaskBuilder(): boolean {
    if (!this.builderParam) {
      return false;
    }
    this.useControlRecentMaskBuilder = this.builderParam!.useControlRecentMaskBuilder;
    return this.useControlRecentMaskBuilder != null;
  }

  private isNeedShowMainMask(): boolean {
    const isControlRecentOnly: boolean = this.sceneSession?.controlTypeToControlRecentMap?.get(
      this.sceneSession?.useControlList?.[0]) ?? false;
    return (this.isSessionActive && this.scenePanelState !== ScenePanelState.RECENT) && !isControlRecentOnly;
  }
}