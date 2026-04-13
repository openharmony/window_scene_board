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

import AppBubbleParams from '@ohos/launchercommon/src/main/ets/buildernode/AppBubbleParams';
import { OpenFolderAddBubble } from '../OpenFolderAddBubble';
import { OpenFolderAppBubbleNode } from './OpenFolderAppBubbleNode';

/**
 * 文件夹+号缓存节点
 */
export class OpenFolderAddBubbleNode extends OpenFolderAppBubbleNode {
  constructor(params: AppBubbleParams) {
    super(params);
    this.wrapBuilder = wrapBuilder(appBubbleBuilder);
    this.params = params;
  }
}

@Builder
function appBubbleBuilder(params: AppBubbleParams) {
  OpenFolderAddBubble({
    item: params.item,
    params: params,
    appItemWidth: params.common.appItemWidth,
  })
}