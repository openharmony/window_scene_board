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

import { LogDomain, LogHelper } from '@ohos/basicutils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, 'TextEmojiHelper');

const emojiCodeRanges = [
  [0x00A9, 0x00AE], // © ®
  [0x203C, 0x2049], // ‼ ⁉
  [0x2122, 0x2139], // ™ ℹ
  [0x2190, 0x21AF], // ↔↕↖↗↘↙ ↩↪
  [0x231A, 0x2328], // ⌚⌛ ⌨
  [0x23CF, 0x23FA], // ⏏ ⏩⏪⏫⏬⏭⏮⏯⏰⏱⏲⏳ ⏸⏹⏺
  [0x24C0, 0x24CF], // Ⓜ
  [0x25A0, 0x27BF], // Miscellaneous Symbols & Dingbats
  [0x2930, 0x293F], // ⤴⤵ 
  [0x2B00, 0x2B5F], // ⬅⬆⬇ ⬛⬜ ⭐ ⭕
  [0x3030, 0x303D], // 〰 〽
  [0x3290, 0x329F], // ㊗ ㊙
  [0xFE0E, 0xFE0F], // VS15, VS16
  [0x1F000, 0x1FAFF], // other emojis
]

export class TextEmojiHelper {

  public isEmoji(textStr: string): boolean {
    return TextEmojiHelper.isEmoji(textStr);
  }

  public static isEmoji(textStr: string): boolean {
    for (const ch of textStr) {
      let unicode = ch.codePointAt(0) ?? 0;

      for (const range of emojiCodeRanges) {
        if (unicode >= range[0] && unicode <= range[1]) {
          log.showInfo(`Text contains emoji: ${ch}=${unicode}`);
          return true;
        }
      }
    }

    return false;
  }
}