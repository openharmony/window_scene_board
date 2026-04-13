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
 * 文件夹展开态Grid的布局参数管理
 * 如背板的透明度,偏移量等
 */
@Observed
export class OpenFolderGridSwiperLayout {
  @Track public bgTranslateX: number = 0;
  @Track public bgTranslateY: number = 0;
  @Track public bgOpacity: number = 0;
  @Track public bgHeight: number = 0;
  @Track public bgWidth: number = 0;
  // 展开态标题栏透明度
  @Track public titleOpacity: number = 0;
  // 展开态导航点
  @Track public isShowIndicator: boolean = false;

  // 展开态控件是否上树
  @Track public isShowOpenFolder: boolean = false;

  // 是否拦截事件，ture: 不允许事件透传 false: 允许事件透传
  @Track public isInterceptEvent: boolean = true;
}