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

/*
 * FolderState状态常量
 * */
export enum FolderState {
  // 小文件夹关闭态
  SMALL_FOLDER_CLOSE,

  // 小文件夹关闭后移位动效过程中
  SMALL_FOLDER_CLOSE_ENDING_PAGE,

  // 大文件夹关闭态
  BIG_FOLDER_CLOSE,

  // 小文件夹打开动效过程中
  SMALL_FOLDER_OPENING,

  // 大文件夹打开动效过程中
  BIG_FOLDER_OPENING,

  // 小文件夹关闭动效过程中
  SMALL_FOLDER_CLOSING,

  // 大文件夹关闭动效过程中
  BIG_FOLDER_CLOSING,

  // 文件夹展开态
  FOLDER_OPEN_STATIC,

  // 小文件夹转换为大文件夹过程中
  CONVERTING_SMALL_TO_BIG,

  // 大文件夹转换为小文件夹动效过程中
  CONVERTING_BIG_TO_SMALL,

  // 文件夹展开态滑动翻页中
  FOLDER_OPEN_SWITCHING,
}

/**
 * 文件夹大小类型：列宽x行高
 */
export enum FolderAreaType {
  AREA_1x1 = '1x1',
  AREA_1x2 = '1x2',
  AREA_2x1 = '2x1',
  AREA_2x2 = '2x2',
  AREA_4x2 = '4x2',
  AREA_1x1_Rtl = '1x1_Rtl',
  AREA_1x2_Rtl = '1x2_Rtl',
  AREA_2x1_Rtl = '2x1_Rtl',
  AREA_2x2_Rtl = '2x2_Rtl',
  AREA_4x2_Rtl = '4x2_Rtl'
}