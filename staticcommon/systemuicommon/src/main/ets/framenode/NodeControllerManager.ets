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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseNodeController } from './BaseNodeController';

const TAG = 'Animation-NodeControllerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * 节点迁移控制器
 */
@ObservedV2
export class NodeControllerManager {
  /**
   * 是否在通知横幅显示
   */
  @Trace public showInBanner: boolean = false;

  /**
   * 迁移至通知横幅
   */
  public moveToBanner(): void {
    this.showInBanner = true;
    log.showInfo('move node to Banner');
  }

  /**
   * 迁移至状态栏
   */
  public moveToStatusBar(): void {
    this.showInBanner = false;
    log.showInfo('move node to StatusBar');
  }
}