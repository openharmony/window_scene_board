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

export class AppIconShadowData {
  @Track public shadowRotateX: number = 0;
  @Track public shadowRotateY: number = 0;
  @Track public shadowRotateAngle: number = 0;
  @Track public shadowTranslateX: number = 0;
  @Track public shadowTranslateY: number = 0;
  @Track public shadowScale: number = 1;
  @Track public shadowOpacity: number = 0;
  @Track public foregroundTranslateX: number = 0;
  @Track public foregroundTranslateY: number = 0;
}