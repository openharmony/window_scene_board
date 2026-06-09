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
import { LiveNotification } from '@ohos/systemuicommon/newIndex';
import { IImmCapLiveSysBtnVm } from './IImmCapLiveSysBtnVm';
import { IImmCapLiveSysProgressVm } from './IImmCapLiveSysProgressVm';
import { IImmersiveLiveVmInjector } from './IImmersiveLiveVmInjector';

/**
 * 实况通知在胶囊上使用时业务注入器抽象层
 */
export interface IImmCapLiveVmInjector extends IImmersiveLiveVmInjector {
  /**
   * 沉浸实况系统卡片按钮业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片按钮业务管理器
   */
  getCardSystemButtonVm(live: LiveNotification): IImmCapLiveSysBtnVm;

  /**
   * 沉浸实况系统卡片进度环业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片进度环业务管理器
   */
  getCardSystemProgressVm(live: LiveNotification): IImmCapLiveSysProgressVm;
}