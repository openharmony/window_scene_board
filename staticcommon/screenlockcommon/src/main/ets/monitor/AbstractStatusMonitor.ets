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

import { CommonUtil } from '../utils/CommonUtil';
import { AbstractObserver, ObserverStageEnum } from './AbstractObserver';


export interface IStatusMonitor {
  registerListener(): void;

  unregisterListener(): void;

  initStatus(): void;
}

export abstract class BaseStatusMonitor<T> extends AbstractObserver<T> implements IStatusMonitor {
  public init(): void {
    this.infoLog('init');
    this.initStatus();
    this.registerListener();
  }

  abstract initStatus(): void

  abstract register(): void

  abstract unregister(): void

  protected initEmptyStatus(): void {
    this.infoLog('no need init status');
  }

  public registerListener(): void {
    this.infoLog('register start');
    CommonUtil.runWithoutException(this.getLogTag(), 'registerListener', () => {
      this.register();
    });
    this.infoLog('register end');
  }

  public unregisterListener(): void {
    this.infoLog('unregister start');
    CommonUtil.runWithoutException(this.getLogTag(), 'unregisterListener', () => {
      this.unregister();
      this.unsubscribeAll();
    });
    this.infoLog('unregister end');
  }

  protected handleStatusChange(data?: T, specialHandleFunc?: Function): void {
    this.debugLog('receive status change');
    CommonUtil.runWithoutException(this.getLogTag(), 'handleStatusChange', () => {
      if (specialHandleFunc) {
        this.debugLog('start special handle');
        specialHandleFunc();
      } else if (!this.needNotify()) {
        this.infoLog('subscribers is empty,no need to notify');
      } else {
        this.infoLog('start default handle');
        this.publishAtStage(ObserverStageEnum.BEFORE, data);
        this.publishAtStage(ObserverStageEnum.PROCESSING, data);
        this.publishAtStage(ObserverStageEnum.AFTER, data);
      }
    });
    this.debugLog('handle status change done');
  }
}