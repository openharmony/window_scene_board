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
import { Context } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseIconResource, IconResource } from './IconResource';

export async function parseIconRes(context: Context,
  iconResInstances: BaseIconResource[]): Promise<BaseIconResource[]> {
  'use concurrent';
  const TAG = 'IconResource-parseIconRes';
  const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
  log.showInfo(`parseIconRes begin, length: ${iconResInstances.length}`);
  return await IconResource.parse(context, iconResInstances);
}