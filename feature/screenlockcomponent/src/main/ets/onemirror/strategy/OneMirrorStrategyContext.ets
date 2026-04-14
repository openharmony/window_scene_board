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

import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { IOneMirrorStrategy } from '../model/IOneMirrorStrategy';
import { OneMirrorDefaultStrategy } from './OneMirrorDefaultStrategy';
import { OneMirrorPocketFoldStrategy } from './OneMirrorPocketFoldStrategy';
import { OneMirrorSmallFoldStrategy } from './OneMirrorSmallFoldStrategy';

const TAG = 'OneMirrorStrategyContext';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 读取一镜到底策略
 */
export class OneMirrorStrategyContext {
  private static sInstance: OneMirrorStrategyContext;
  private strategy: IOneMirrorStrategy = new OneMirrorDefaultStrategy();

  private constructor() {
  }

  /**
   * 获取Instance单例
   *
   * @returns Instance单例
   */
  public static getInstance(): OneMirrorStrategyContext {
    if (!OneMirrorStrategyContext.sInstance) {
      OneMirrorStrategyContext.sInstance = new OneMirrorStrategyContext();
    }
    return OneMirrorStrategyContext.sInstance;
  }

  /**
   * 初始化一镜到底策略
   */
  public init(): void {
    if (DeviceHelper.isSmallFoldProduct()) {
      this.strategy = new OneMirrorSmallFoldStrategy();
    }
    log.showInfo(TAG, `init OneMirrorStrategy: ${this.strategy.getName()}`);
  }

  /**
   * 获取一镜到底策略
   *
   * @returns 一镜到底策略
   */
  public getStrategy(): IOneMirrorStrategy {
    return this.strategy;
  }
}