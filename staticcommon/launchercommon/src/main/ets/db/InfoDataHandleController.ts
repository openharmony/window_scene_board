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
import { RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import InsertBatchHandler from './InsertBatchHandler';
import MassUpdateHandler from './MassUpdateHandler';
import MinorUpdateHandler from './MinorUpdateHandler';
import { HandleType } from './RdbTaskPoolHelper';

export default class InfoDataHandleFactory {
  private static mInstance: InfoDataHandleFactory;
  private handlerMap: Map<HandleType, IDataHandler> = new Map();

  public static getInstance(): InfoDataHandleFactory {
    if (!InfoDataHandleFactory.mInstance) {
      InfoDataHandleFactory.mInstance = new InfoDataHandleFactory();
    }
    return InfoDataHandleFactory.mInstance;
  }

  private constructor() {
    this.handlerMap.set(HandleType.INSERT_BATCH, new InsertBatchHandler());
    this.handlerMap.set(HandleType.MINOR_UPDATE, new MinorUpdateHandler());
    this.handlerMap.set(HandleType.MASS_UPDATE, new MassUpdateHandler());
  }

  public getHandler(type: HandleType): IDataHandler {
    if (!this.handlerMap.has(type)) {
      return new MinorUpdateHandler();
    }
    return this.handlerMap.get(type) ?? new MinorUpdateHandler();
  }
}

export interface IDataHandler {
  handleDataToRdb(tableName: string, gridItemList: GridLayoutItemInfo[], rdbStoreHelper: RdbStoreHelper,
    container?: number, screenId?: number, reason?: string): Promise<void>;
}