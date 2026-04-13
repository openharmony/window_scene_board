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
import systemParameter from '@ohos.systemParameterEnhance';
import { LogDomain, LogHelper } from './BasicCommon';
import { FontScaleState } from './fontScaleState';

const TAG = 'FontScaleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class FontScaleManager {
  private fontScaleState = new FontScaleState();

  constructor() {
    this.initFontScaleState();
  }
  /**
   * 获取系统原始字体放大倍数
   */
  public getSysFontScaleState(): FontScaleState {
    return this.fontScaleState;
  }
  /**
   * 设置系统原始字体放大倍数
   *
   * @param scale 字体系数
   */
  public setSysFontScale(scale: number): void {
    this.fontScaleState.fontSizeScale = scale;
  }

  /**
   * 使用从数据库查询的系统字体放大倍数进行初始化
   */
  public initFontScaleState(): void {
    let scaleSize = systemParameter.getSync('persist.sys.font_scale_for_user0', '1');
    log.showInfo(`initialize fontSizeScale:${scaleSize}`);
    this.setSysFontScale(Number(scaleSize));
  }
}

export const fontScaleManager = new FontScaleManager();