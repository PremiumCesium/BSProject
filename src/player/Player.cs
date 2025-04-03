using Godot;
using System;

public partial class Player : CharacterBody3D
{
    [Export] public float PlayerSpeed { get; set; } = 5.0f;
    [Export] public float JumpForce { get; set; } = 3.0f;
    [Export] public float Gravity { get; set; } = 8.0f;
    [Export] public float MouseSensitivity { get; set; } = 0.5f;

    private Node3D player;
    private Node3D head;
    private Vector3 direction = Vector3.Zero;
    private float camXDeg = 0.0f;

    public override void _Ready()
    {
        Input.MouseMode = Input.MouseModeEnum.Captured;
        player = GetNode<Node3D>(".");
        head = GetNode<Node3D>("head");
    }

    public override void _Input(InputEvent @event)
    {
        Look(@event);
        
        if (@event.IsActionPressed("ui_cancel"))
        {
            Input.MouseMode = Input.MouseModeEnum.Visible;
        }
    }

    private void Look(InputEvent @event)
    {
        if (@event is InputEventMouseMotion mouseEvent)
        {
            player.RotateY(
                -Mathf.DegToRad(mouseEvent.Relative.X * MouseSensitivity));
            camXDeg -= mouseEvent.Relative.Y * MouseSensitivity;
            camXDeg = Mathf.Clamp(camXDeg, -90.0f, 90.0f);
            head.RotationDegrees = new Vector3(camXDeg, head.RotationDegrees.Y,
                head.RotationDegrees.Z);
        }
        else if (@event is InputEventKey keyEvent)
        {
            if (Input.IsKeyPressed(Key.Escape))
            {
                GetTree().Quit();
            }
        }
    }

    public override void _PhysicsProcess(double delta)
    {
        Movement(delta);
    }

    private void Movement(double delta)
    {
        direction = Input.GetAxis("left", "right") * player.Basis.X +
                    Input.GetAxis("forward", "backwards") * player.Basis.Z;
        Velocity = direction.Normalized() * PlayerSpeed +
                   Velocity.Y * Vector3.Up;

        if (Input.IsActionJustPressed("jump") && IsOnFloor())
        {
            Velocity = new Vector3(Velocity.X, JumpForce, Velocity.Z);
        }
        else
        {
            Velocity = new Vector3(Velocity.X,
                Velocity.Y - Gravity * (float)delta, Velocity.Z);
        }

        MoveAndSlide();
    }
}