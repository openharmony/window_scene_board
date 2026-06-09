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

import Notification from '@ohos.notificationManager';
import resourceManager from '@ohos.resourceManager';
import { WantAgent } from '@kit.AbilityKit';

export default interface INotificationConfig {
    /**
     * 构建通知文字内容
     *
     * @param resourceManager
     * @param type
     * @param version
     * @returns Notification.NotificationBasicContent | undefined
     */
    buildTextContent(
        resourceManager: resourceManager.ResourceManager,
        type: number,
        version?: string
    ): Notification.NotificationBasicContent | undefined;

    /**
     * 主题参数
     *
     * @param editorId
     * @param status
     * @param errCode
     * @param version
     * @returns Promise<WantAgent | null> 返回点击通知后的Want参数
     */
    getWantAgent(editorId: string, status: number, errCode: number, version?: string): Promise<WantAgent | null>;

    /**
     * 构建通知id
     *
     * @param version
     * @returns number 返回通知id
     */
    getNotificationId(version?: string): number;
}