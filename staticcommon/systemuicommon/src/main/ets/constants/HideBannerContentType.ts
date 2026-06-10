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
 * 应用横幅通知展示类型
 */
export enum HideBannerContentType {
  /**
   * 跟随系统，跟随全局横幅通知隐藏内容配置
   */
  FOLLOW_SYSTEM = 0,
  /**
   * 始终，隐藏横幅通知内容，不受全局横幅通知隐藏内容配置影响
   */
  ALWAYS = 1,
  /**
   * 从不，不隐藏横幅通知内容，不受全局横幅通知隐藏内容配置影响
   */
  NEVER = 2,
}