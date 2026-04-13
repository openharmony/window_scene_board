/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import type { SmartDockStyleConfig } from '../SmartDockStyleConfig';

/**
 * smartdock style interface
 */
export interface SmartDockStyleInterface {

  /**
   * get SmartDockStyleConfig
   */
  getStyleConfig: () => SmartDockStyleConfig;

  /**
   * update drag effective area when dockList changed
   */
  updateDockParams: (deviceType: string) => Promise<void>;

  /**
   * 初始化dock栏元素中心点x坐标
   * @param dockCenter 当前dock栏中心点
   */
  initDockItemCenterArray: (dockCenter: number) => void;

  /**
   * 获取含指定元素个数的dock栏中索引对应元素x坐标
   * @param length dock栏元素个数 index元素索引
   */
  getDockItemCenter: (length: number, index: number) => number;

}