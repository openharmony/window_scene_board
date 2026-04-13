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

// AppBubble公共参数
export default class AppBubbleCommonParams {
  //文件夹自身对象
  public bindFolderId: string = '';

  public isSmallFolder : boolean = false;

  public appItemWidth: number = 0;

  public nameSize: number = 0;

  public nameHeight: number = 0;

  public nameWidth: number = 0;

  public mIconNameMargin: number = 0;

  public mFolderIconRadius: number = 0;

  public nameLines: number = 0;

  public iconRadius: number = 0;

  // 该图标在对应文件夹折叠态中的图标大小
  public iconSizeInFolder: number = 1;
}
