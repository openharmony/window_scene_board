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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { MeasureUtils, UIContext } from '@ohos.arkui.UIContext';
import measure, { MeasureOptions } from '@ohos.measure';

const TAG = 'ArkUIAdapter';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

export enum ViewName {
  UNKNOWN = 'Unknown',
  STATUS_BAR_VIEW = 'StatusBarView',
  DROPDOWN_VIEW = 'DropdownView',
  BANNER_VIEW = 'BannerView',
}

export class ArkUIAdapter {
  /**
   * 定义全局UI上下文
   */
  public static uiContext: UIContext | undefined = undefined;

  /**
   * 记录每个View的ui上下文
   */
  private static viewUiContext: Map<ViewName, UIContext> = new Map();

  public static setViewUiContext(viewName: ViewName, uiContext: UIContext): void {
    this.viewUiContext.set(viewName, uiContext);
  }

  public static getUiContextByViewName(viewName: ViewName): UIContext {
    const viewUiContext = this.viewUiContext.get(viewName);
    return viewUiContext ?? this.uiContext;
  }

  public static runWithScope(callback: () => void, uiContext?: UIContext): void {
    const currentUiContext = uiContext ?? ArkUIAdapter.uiContext;
    if (currentUiContext) {
      currentUiContext.runScopedTask(() => {
        callback();
      })
    } else {
      log.showFatal('runWithScope has no uiContext');
      callback();
    }
  }

  /*
  **在上下文中执行vp2px
   */
  public static vp2px(number): number {
    if (!this.uiContext) {
      log.showWarn('vp2px has no uiContext');
      return vp2px(number);
    } else {
      return this.uiContext.vp2px(number);
    }
  }

  /*
  **在上下文中执行px2vp
   */
  public static px2vp(number): number {
    if (!this.uiContext) {
      log.showWarn('px2vp has no uiContext');
      return px2vp(number);
    } else {
      return this.uiContext.px2vp(number);
    }
  }

  /**
   * 在上下文中执行getMeasureUtils
   */
  public static getMeasureUtils(uiContext: UIContext): MeasureUtils {
    if (!ArkUIAdapter.uiContext) {
      log.showWarn('getMeasureUtils has no uiContext');
      return uiContext.getMeasureUtils();
    } else {
      return ArkUIAdapter.uiContext.getMeasureUtils();
    }
  }

  /**
   * 在上下文中获取文本宽度px
   */
  public static measureText(viewName: ViewName, measureOptions: MeasureOptions): number {
    const uiContext = ArkUIAdapter.getUiContextByViewName(viewName);
    let textWidth: number = 0;
    try {
      if (!uiContext) {
        log.showWarn('getMeasureUtils has no uiContext');
        textWidth = measure.measureText(measureOptions);
      } else {
        textWidth = uiContext.getMeasureUtils().measureText(measureOptions);
      }
    } catch(err) {
      log.showError(`measureText error, code: ${err?.code}, message: ${err?.message}`);
    }
    if (Number.isNaN(textWidth)) {
      log.showWarn('textWidth is NaN');
      return 0;
    }
    return textWidth;
  }
}