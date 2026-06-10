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

import { LogDomain, LogHelper, SingleBase, SingleContext, } from '@ohos/basicutils';
import { SCBSceneContainerSession } from '@ohos/windowscene';
import { SCBRecentSessionsViewModel } from '../SCBRecentSessionsViewModel';

const defaultFunction = () : void => {};
const TAG = 'RecentFocusController';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export interface RecentFocusModel {
  setRecentSelectedIndexCallback : ((index: number) => void),
  getRecentSelectedIndexCallback : (() => number),
}

export class RecentFocusController extends SingleBase {
  public static singleName: string = 'RecentFocusController';
  private mScreenId: number = -1;
  private recentFocusModel: RecentFocusModel | null = null;

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.mScreenId = ctx?.extendScreenId ?? 0;
  }

  /**
   * get ScreenId bind to this
   * @returns
   */
  public getScreenId(): number {
    return this.mScreenId;
  }

  /**
   * set the selected index of recent
   * @param index
   */
  public setRecentSelectedIndex(index: number): void {
    if (this.recentFocusModel === null) {
      log.showError(`setRecentSelectedIndex,recentFocusModel is null`);
      return;
    }
    log.showInfo(`setRecentSelectedIndex ${this.mScreenId}, ${index}`);
    this.recentFocusModel.setRecentSelectedIndexCallback(index);
  }

  /**
   * get the selected index of recent
   * @returns
   */
  public getRecentSelectedIndex(): number {
    if (this.recentFocusModel === null) {
      log.showError(`getRecentSelectedIndex,recentFocusModel is null`);
      return -1;
    }
    log.showInfo(`getRecentSelectedIndex ${this.mScreenId}`);
    return this.recentFocusModel.getRecentSelectedIndexCallback();
  }

  /**
   * get the SCBSceneContainerSession corresponding to current index
   * @returns
   */
  public getRecentSelectedItem(): SCBSceneContainerSession | null {
    if (this.recentFocusModel === null) {
      log.showError(`getRecentSelectedItemByIndex,recentFocusModel is null`);
      return null;
    }
    const index: number = this.getRecentSelectedIndex();
    log.showInfo(`getRecentSelectedItem ${this.mScreenId}, ${index}`);
    return this.getRecentSelectedItemByIndex(index);
  }

  /**
   * get the SCBSceneContainerSession By index
   * @returns
   */
  public getRecentSelectedItemByIndex(index: number): SCBSceneContainerSession | null {
    let recentSessionsInfo = SCBRecentSessionsViewModel.getInstance(this.singleContext).getRecentSessionList();
    if (index < 0 || index >= recentSessionsInfo.length) {
      return null;
    }
    const sessionId = recentSessionsInfo[index].sessionId;
    let sceneContainer: SCBSceneContainerSession | null = null;
    let recentContainerSessionList =
      SCBRecentSessionsViewModel.getInstance(this.singleContext).getContainerSessionList();
    for (let element of recentContainerSessionList) {
      if (element.primarySession?.session.persistentId === sessionId) {
        sceneContainer = element;
        break;
      }
    }
    log.showInfo('getRecentSelectedItemByIndex %{public}d, %{public}d, %{public}s',
      this.mScreenId, index, recentSessionsInfo[index].bundleName);
    return sceneContainer;
  }

  /**
   * register the recentFocusModel
   * @param focusModel
   */
  public registerRecentFocusModel(focusModel: RecentFocusModel): void {
      this.recentFocusModel = focusModel;
  }

  /**
   * destroy the recentFocusModel
   */
  public destroy(): void {
    this.recentFocusModel = null;
  }

  /**
   * reset the selected index of recent
   */
  public resetSelectedIndex(): void {
    this.setRecentSelectedIndex(-1);
  }

}
