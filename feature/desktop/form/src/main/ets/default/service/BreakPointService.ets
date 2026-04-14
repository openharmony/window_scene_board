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

export interface GridLayoutOptions {
  rowOption: GridRowOptions,
  colOption: GridColOptions
}

/**
 * 栅格组件参数配置
 */
export class BreakPointService {
  public static readonly XS_SM = 600;

  public static readonly SM_MD = 840;

  // 600以下表示小宽度设备（手机），600~840表示中等宽度设备（可折叠设备），840以上表示大宽度设备（平板）
  private static gridOptions: GridLayoutOptions = {
    rowOption: {
      gutter: { x: { xs: 8, sm: 12, md: 16 }, y: { xs: 8, sm: 12, md: 16 } },
      columns: { xs: 4, sm: 8, md: 12 },
      breakpoints: {
        value: [BreakPointService.XS_SM + 'vp', BreakPointService.SM_MD + 'vp'],
        reference: BreakpointsReference.WindowSize
      }
    },
    colOption: {
      span: { xs: 4, sm: 6, md: 8 },
      offset: { xs: 0, sm: 1, md: 2 }
    }
  }

  static rowColOptions(): GridLayoutOptions {
    return BreakPointService.gridOptions;
  }
}