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
import { GlobalPersistInfo } from '../../remote/model/GlobalPersistInfo';

export interface GlobalPersistServiceApi {
  /**
   * 设置保存持久化数据
   * @param globalPersistInfo 持久化数据信息
   */
  setGlobalPersist(globalPersistInfo: GlobalPersistInfo): Promise<boolean>;

  /**
   * 获取持久化数据
   * @returns 持久化数据
   */
  getGlobalPersist(): Promise<GlobalPersistInfo | undefined>;

  /**
   * 清除持久化数据data
   * @returns
   */
  clearGlobalPersistData(): Promise<void>
}

