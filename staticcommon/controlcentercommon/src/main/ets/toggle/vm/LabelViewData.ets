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

@Observed
export class FontViewData {
  // label文字尺寸
  public fontSize: number = 0;

  // label文字行高
  public lineHeight: number = 0;

  // label文字粗细程度
  public fontWeight: FontWeight = 0;

  // hover状态下label文字尺寸
  public hoverFontSize: number = 0;

  // label长度
  public labelWidth: number = 0;

  // 是否是中文模式
  public isChineseMode: boolean = false;

  // 是否是英文模式
  public isEnglishMode: boolean = false;

  // 是否是藏文模式
  public isTibetanMode: boolean = false;

  // 是否是维语模式
  public isUyghurMode: boolean = false;

  // 是否镜像语言
  public isRTL: boolean = false;
}