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

import { LiveCapsuleModel } from './LiveCapsuleModel';
import { LiveCapsuleType, LiveProgressModel } from './LiveCommonModel';

/**
 * 进度类实况胶囊数据
 */
export class LiveCapsuleProgressModel extends LiveCapsuleModel {
  readonly capsuleType: LiveCapsuleType = LiveCapsuleType.PROGRESS;

  /**
   * 进度数据
   */
  progress?: LiveProgressModel;

  /**
   * 胶囊的内容
   */
  content?: string;
}