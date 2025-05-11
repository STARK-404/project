export function generateCaptcha() {
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  canvas.width = 150;
  canvas.height = 50;

  // Generate random string
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  let captchaText = '';
  for (let i = 0; i < 6; i++) {
    captchaText += chars.charAt(Math.floor(Math.random() * chars.length));
  }

  // Draw background
  ctx.fillStyle = '#0F3460';
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Add noise
  for (let i = 0; i < 50; i++) {
    ctx.strokeStyle = `rgba(${Math.random() * 255},${Math.random() * 255},${Math.random() * 255},0.5)`;
    ctx.beginPath();
    ctx.moveTo(Math.random() * canvas.width, Math.random() * canvas.height);
    ctx.lineTo(Math.random() * canvas.width, Math.random() * canvas.height);
    ctx.stroke();
  }

  // Draw text
  ctx.font = 'bold 30px Space Mono';
  ctx.fillStyle = '#4CC9F0';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.fillText(captchaText, canvas.width/2, canvas.height/2);

  return {
    image: canvas.toDataURL(),
    text: captchaText
  };
}

export function refreshCaptcha(imgElement) {
  const captcha = generateCaptcha();
  imgElement.src = captcha.image;
  return captcha.text;
}