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

/**
 * 该文件只用于导出ts文件，导出ets文件要使用根目录的index.ets文件中。
 */
export { TrayManager } from './service/TrayManager';
export { createStatusBarStub } from './service/StatusBarServiceStub';
export {
  StatusBarConnectEvent,
  StatusBarServiceEventManager
} from './service/StatusBarServiceEventManager';
export type { StatusBarServiceInfo } from './service/StatusBarServiceEventManager';
export type { BundleInfo } from './service/TrayManager';
export { AppClientNotifier } from './service/AppClientNotifier';