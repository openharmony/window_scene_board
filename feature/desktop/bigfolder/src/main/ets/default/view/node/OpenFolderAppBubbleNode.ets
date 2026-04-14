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
import { BaseNodeController } from '@ohos/launchercommon/src/main/ets/buildernode/BaseNodeController';
import { OpenFolderAppBubble } from '../OpenFolderAppBubble';

/**
 * mission info
 */
export class OpenFolderAppBubbleNode extends BaseNodeController<AppBubbleParams> {
  constructor(params: AppBubbleParams) {
    super();
    this.wrapBuilder = wrapBuilder(appBubbleBuilder);
    this.params = params;
  }
}

@Builder
function appBubbleBuilder(params: AppBubbleParams) {
  OpenFolderAppBubble({
    // 公共
    bindFolderId: params.common.bindFolderId,
    isSmallFolder: params.common.isSmallFolder,
    appItemWidth: params.common.appItemWidth,
    nameSize: params.common.nameSize,
    nameHeight: params.common.nameHeight,
    nameWidth: params.common.nameWidth,
    mFolderIconRadius: params.common.mFolderIconRadius,
    nameLines: params.common.nameLines,
    mIconNameMargin: params.common.mIconNameMargin,
    iconRadius: params.common.iconRadius,

    // appBubble特有
    item: params.item,
    pageIndex: params.pageIndex,
    index: params.index,
    openFolderIconNameOpt: params.openFolderIconNameOpt,
    aniParameters: params.openFolderAniParams,
    forceShowBadge: params.forceShowBadge,
  })
}