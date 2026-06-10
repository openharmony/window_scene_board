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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SingleItemSqueezeEngine } from './SingleItemSqueezeEngine';
import { DragGridPosition } from '../../../common/type/CommonTypes';

const TAG = 'ForwardSingleItemSqueezeEngine';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 单元素前向挤位引擎
 *
 * @since 2024/04/28
 */
export class ForwardSingleItemSqueezeEngine extends SingleItemSqueezeEngine {
  protected getSqueezeDirection(x: number, y: number, isZSqueeze: boolean, position: DragGridPosition): boolean {
    return false;
  }
}