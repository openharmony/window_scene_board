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

import { CardItemInfo } from '../bean/CardItemInfo';

export class VoiceInStackExposeEvent {
  public static readonly eventTypeName: string = 'VoiceInStackExposeEvent';
  public cardItemList: CardItemInfo[] = [];
  public stackPage: number = 0;
  public topCardItem: CardItemInfo = new CardItemInfo();
}

export function createVoiceInStackExposeEvent(
  cardItemList: CardItemInfo[], stackPage: number, topCardItem: CardItemInfo): VoiceInStackExposeEvent {
  let event: VoiceInStackExposeEvent = new VoiceInStackExposeEvent();
  event.cardItemList = cardItemList;
  event.stackPage = stackPage;
  event.topCardItem = topCardItem;
  return event;
}