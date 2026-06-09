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

/**
 * 承载大主题内部规范的主题内容配置描述文件
 */
export interface ContentDescription {
  id: string;

  origin: string;

  applyFrom?: string;

  movingPhoto?: MovingPhotoCfg;
}

/**
 * MovingPhoto 配置文件
 */
export interface MovingPhotoCfg {
  /**
   * 是否启用MovingPhoto
   */
  enable: boolean;

  /**
   * MovingPhoto视频文件路径
   */
  src: string;

  /**
   * 本次操作的时间戳，home和lock中的applyTime相同，表示为同一套系MovingPhoto资源
   */
  applyTime: string;
}