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
import { LiveNotification } from '../model/LiveNotification';

/**
 * 实况胶囊生命周期VM
 */
export interface ILiveCapsuleLifecycleVm {
  /**
   * 获取胶囊的显示时间
   * @param id
   * @returns
   */
  getCapsuleShowTime(id: number): number;

  /**
   * 删除胶囊统计
   * @param id
   */
  deleteLifecycleInfo(id: number): void;

  /**
   * 更新胶囊的显隐状态
   * @param liveList
   * @returns
   */
  updateCapsuleShow(liveList: LiveNotification[]): Promise<void>;
}
