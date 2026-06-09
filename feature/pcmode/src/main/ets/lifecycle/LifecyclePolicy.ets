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

import { LogHelper } from '@ohos/basicutils';
import { SCBSceneContainerSessionArray,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty } from '@ohos/windowscene';
import { LogUtil } from '../utils/LogUtil';
import { IFreeWindowsViewModel } from '../presenter/IFreeWindowsViewModel';
import { ILifecyclePolicy } from './ILifecyclePolicy';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ViewModelConstant } from '../constants/BaseConstants';

export class LifecyclePolicy implements ILifecyclePolicy {
  protected tag = 'LifecyclePolicy';
  protected screenProperty: SCBScreenProperty;
  protected presenter: IFreeWindowsViewModel;
  protected log: LogHelper;
  private maxForegroundWindowNum: number = 0;

  constructor(presenter: IFreeWindowsViewModel) {
    this.presenter = presenter;
    this.screenProperty = this.presenter.getScreenProperty();
    this.log = LogUtil.getInstance().createLogHelper(this.tag, this.screenProperty.screenId)
  }

  onStart(): void {
    const maxForegroundWindowNum = SCBSceneSessionManager.getInstance().getMaxForegroundWindowNum();
    this.updateForegroundWindowNum(maxForegroundWindowNum);
  }

  onDestroy(): void {
  }

  public minimizeAllScene() {
    this.log.showInfo(`[SCBMain]onMinimizeAllScene`);
    this.presenter.getContainerSessionList().forEach((container) => {
      if (container.isActive) {
        this.minimizeContainer(container);
      }
    })
  }

  public updateForegroundWindowNum(windowNum: number): void {
    if (windowNum) {
      // 非自由多窗下也更新此值，进入自由多窗后生效
      this.maxForegroundWindowNum = windowNum;
    }
  }

  public minimizeContainer(container: SCBSceneContainerSession): void {
    container.needRenderVisibility.setVisibilityWithDfx(false, this.tag, 'minimizeContainer');
    container.requestBackground();
  }

}