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
 * Dock区域类型
 */
export const enum DockRegionType {
  RESIDENT = 'resident', // 常驻区
  RECENT = 'recent', // 最近任务区
  COLLABORATION = 'collaboration', // 多屏协同区
  OTHER = 'other', // 其它（用于DT）
}

/**
 * 应用状态
 */
export const enum AppStateType {
  PREPARE, /** 应用准备初始化 **/
  INIT, /**应用完成初始化 **/
  FOREGROUND, /** 应用在前台 **/
  FOCUS, /** 应用获焦 **/
  BACKGROUND, /** 应用在后台 **/
  EXIT /** 应用退出 **/
}