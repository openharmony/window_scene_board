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
 * 文件夹展开前后背板布局参数
 */
export class OpenFolderBackgroundLayout {
  // 展开前背板宽度
  public closedWidth: number = 0;
  // 展开前背板高度
  public closedHeight: number = 0;
  // 展开后背板宽度
  public openedWidth: number = 0;
  // 展开后背板高度
  public openedHeight: number = 0;
  // 展开后背板Margin
  public openedMargin: number = 0;
  // 背板圆角（与关闭态保持一致）
  public radius: number = 0;
}