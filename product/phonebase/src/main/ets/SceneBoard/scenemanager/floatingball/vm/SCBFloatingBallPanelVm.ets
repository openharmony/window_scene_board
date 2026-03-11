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
import { LogDomain, Logger } from '@ohos/basicutils';
import { Singleton } from '@ohos/systemuicommon/newTsIndex';
import {
  SCBSceneSessionManager,
  SpecificPanelZOrder
} from '@ohos/windowscene';

const TAG = 'SCBFloatingBallPanelVm';
const log = Logger.getLogHelper(LogDomain.WINDOW);

@ObservedV2
export class SCBFloatingBallPanelVm {
  @Singleton.decorate()
  public static get instance() {
    return new SCBFloatingBallPanelVm();
  }
  public propertyChanged: boolean = false;
  public firstAppear: boolean = true;

  public propertyWidth: number = 0;
  public propertyHeight: number = 0;

  @Trace public sessionList: sceneSessionManager.SceneSession[] = [];

  private zOrder = SpecificPanelZOrder.FLOATING_BALL as number;
  private createSessionCallback?: (session: sceneSessionManager.SceneSession) => void;

  private constructor() {
  }

  public init(): void {
    try {
      SCBSceneSessionManager.getInstance().registerCreateSpecificSceneCallback(this.onCreateSpecificScene, this.zOrder);
    } catch (err) {
      log.error(TAG, 'aboutToAppear err:', err);
    }
  }

  public updateProperty(width: number, height: number): void {
    this.propertyWidth = width;
    this.propertyHeight = height;
    log.showInfo(TAG, `update property width ${width}, height ${height}`);
  }

  public removeSession(persistentIds: number[]): void {
    log.showInfo(TAG, `Remove session, id: ${persistentIds.toString()}`);
    this.sessionList = this.sessionList.filter((session) => !persistentIds.includes(session.persistentId));
  }

  public registerOnCreateSession(callback: (session: sceneSessionManager.SceneSession) => void): void {
    this.createSessionCallback = callback;
    for (const session of this.sessionList) {
      this.createSessionCallback(session);
    }
  }

  public unRegisterOnCreateSession(): void {
    log.showInfo(TAG, 'unRegisterOnCreateSession');
    this.createSessionCallback = undefined;
  }

  private onCreateSpecificScene = async (session: sceneSessionManager.SceneSession): Promise<void> => {
    log.showInfo(TAG, `createSpecificScene, type: ${session.type}, id: ${session.persistentId}`);
    this.sessionList.push(session);
    if (this.createSessionCallback) {
      log.showInfo(TAG, `createSpecificScene, type: ${session.type}, id: ${session.persistentId}---> callback`);
      this.createSessionCallback(session);
    }
  };
}