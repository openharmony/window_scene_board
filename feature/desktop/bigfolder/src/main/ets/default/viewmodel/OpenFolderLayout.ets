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

import { SingletonHelper } from '@ohos/basicutils';
import { OpenFolderAppBubbleLayout } from '@ohos/launchercommon/Index';
import { OpenFolderBackgroundLayout } from './OpenFolderBackgroundLayout';
import { OpenFolderGridSwiperLayout } from './OpenFolderGridSwiperLayout';
import { OpenFolderTitleLayout } from './OpenFolderTitleLayout';

const TAG: string = 'OpenFolderLayout';

/**
 * 文件夹展开态布局总管理类
 */
class OpenFolderLayout {
  private gridSwiperLayout: OpenFolderGridSwiperLayout = new OpenFolderGridSwiperLayout();
  private titleLayout: OpenFolderTitleLayout = new OpenFolderTitleLayout();
  private backgroundLayout: OpenFolderBackgroundLayout = new OpenFolderBackgroundLayout();

  public getGridSwiperLayout(): OpenFolderGridSwiperLayout {
    return this.gridSwiperLayout;
  }

  public getTitleLayout(): OpenFolderTitleLayout {
    return this.titleLayout;
  }

  /**
   * 展开态背板布局参数
   *
   * @returns OpenFolderBackgroudLayout
   */
  public getBackgroundLayout(): OpenFolderBackgroundLayout {
    return this.backgroundLayout;
  }
}

// 单例
export let openFolderLayout: OpenFolderLayout = SingletonHelper.getInstance(OpenFolderLayout, TAG);