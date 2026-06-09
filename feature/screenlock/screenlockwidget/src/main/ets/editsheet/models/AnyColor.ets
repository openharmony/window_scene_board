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

export enum AnyColorTool {
  None,
  EyeDropper,
  ColorPanel,
  Placeholder,
}

export interface AnyColorInterface {
  color?: ResourceColor;
  borderColor?: ResourceColor;
  tool?: AnyColorTool;
}

export class AnyColor {
  color?: ResourceColor;
  borderColor?: ResourceColor;
  tool: AnyColorTool;

  constructor(params: AnyColorInterface) {
    this.color = params.color;
    this.borderColor = params.borderColor;
    this.tool = params.tool ?? AnyColorTool.None;
  }
}

export const EDIT_COLOR_ARRAY: Array<AnyColor> = [
  new AnyColor({ color: Color.White, borderColor: 'rgba(204, 204, 204,1)' }),
  new AnyColor({ color: 'rgba(135, 135, 135, 1)', borderColor: 'rgba(110, 110, 110, 1)' }), // #878787
  new AnyColor({ color: Color.Black, borderColor: 'rgba(102, 102, 102, 1)' }),
  new AnyColor({ color: 'rgba(173, 107, 44, 1)', borderColor: 'rgba(147, 81, 18, 1)' }), // #AD6B2C
  new AnyColor({ color: 'rgba(230, 193, 124, 1)', borderColor: 'rgba(204, 167, 98, 1)' }), // #E6C17C
  new AnyColor({ color: 'rgba(205, 133, 228, 1)', borderColor: 'rgba(164, 111, 191, 1)' }), // #CD85E4
  new AnyColor({ color: 'rgba(168, 156, 255, 1)', borderColor: 'rgba(149, 120, 202, 1)' }), // #A89CFF
  new AnyColor({ color: 'rgba(132, 193, 250, 1)', borderColor: 'rgba(106, 154, 200, 1)' }), // #84C1FA
  new AnyColor({ color: 'rgba(146, 214, 204, 1)', borderColor: 'rgba(99, 167, 157, 1)' }), // #92D6CC
  new AnyColor({ color: 'rgba(161, 216, 164, 1)', borderColor: 'rgba(106, 155, 106, 1)' }), // #a1d8a4
  new AnyColor({ color: 'rgba(189, 219, 105, 1)', borderColor: 'rgba(152, 176, 86, 1)' }), // #BDDB69
  new AnyColor({ color: 'rgba(243, 126, 180, 1)', borderColor: 'rgba(185, 85, 118, 1)' }), // #f37eb4
  new AnyColor({ color: 'rgba(248, 120, 100, 1)', borderColor: 'rgba(206, 84, 60, 1)' }), // #E87864
  new AnyColor({ color: 'rgba(255, 152, 88, 1)', borderColor: 'rgba(223, 115, 48, 1)' }), // #ff9858
  new AnyColor({ color: 'rgba(255, 188, 91, 1)', borderColor: 'rgba(223, 147, 36, 1)' }), // #ffbc5b
  new AnyColor({ color: 'rgba(255, 226, 82, 1)', borderColor: 'rgba(195, 170, 33, 1)' }), // #ffe252
  new AnyColor({ color: 'rgba(229, 236, 115, 1)', borderColor: 'rgba(180, 187, 46, 1)' }), // #E5EC73
  new AnyColor({ color: 'rgba(158, 79, 125, 1)', borderColor: 'rgba(132, 53, 99, 1)' }), // #9e4f7d
  new AnyColor({ color: 'rgba(154, 86, 77, 1)', borderColor: 'rgba(128, 60, 51, 1)' }), // #9a564d
  new AnyColor({ color: 'rgba(159, 118, 79, 1)', borderColor: 'rgba(133, 92, 53, 1)' }), // #9f764f
  new AnyColor({ color: 'rgba(99, 128, 64, 1)', borderColor: 'rgba(73, 102, 38, 1)' }), // #638040
  new AnyColor({ color: 'rgba(79, 116, 158, 1)', borderColor: 'rgba(53, 90, 132, 1)' }), // #4f749e
  new AnyColor({ color: 'rgba(106, 99, 199, 1)', borderColor: 'rgba(80, 73, 173, 1)' }),// #6A63C7
];

export const HIS_COLOR_MAP: Map<string, string> = new Map<string, string>([
  ['rgba(137, 129, 247, 0.85)', 'rgba(168, 156, 255, 1)'],
  ['rgba(134, 197, 227, 0.85)', 'rgba(132, 193, 250, 1)'],
  ['rgba(146, 214, 204, 0.85)', 'rgba(146, 214, 204, 1)'],
  ['rgba(146, 196, 141, 0.85)', 'rgba(161, 216, 164, 1)'],
  ['rgba(230, 124, 146, 0.85)', 'rgba(243, 126, 180, 1)'],
  ['rgba(232, 115, 97, 0.85)', 'rgba(248, 120, 100, 1)'],
  ['rgba(237, 149, 95, 0.85)', 'rgba(255, 152, 88, 1)'],
  ['rgba(249, 188, 100, 0.85)', 'rgba(255, 188, 91, 1)'],
  ['rgba(245, 220, 98, 0.85)', 'rgba(255, 226, 82, 1)'],
  ['rgba(189, 219, 105, 0.85)', 'rgba(189, 219, 105, 1)']
]);